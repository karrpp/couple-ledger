-- 커플
CREATE TABLE couples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invite_code TEXT UNIQUE NOT NULL,
  user_a UUID,
  user_b UUID,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 사용자
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  kakao_id TEXT UNIQUE NOT NULL,
  nickname TEXT NOT NULL,
  avatar_url TEXT,
  couple_id UUID REFERENCES couples(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- couples FK (circular reference)
ALTER TABLE couples ADD CONSTRAINT fk_user_a FOREIGN KEY (user_a) REFERENCES users(id);
ALTER TABLE couples ADD CONSTRAINT fk_user_b FOREIGN KEY (user_b) REFERENCES users(id);

-- 카테고리
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID REFERENCES couples(id),
  name TEXT NOT NULL,
  icon TEXT NOT NULL,
  keywords TEXT[],
  sort_order INT DEFAULT 0,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 지출
CREATE TABLE expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) NOT NULL,
  couple_id UUID REFERENCES couples(id) NOT NULL,
  category_id UUID REFERENCES categories(id) NOT NULL,
  amount INT NOT NULL,
  memo TEXT,
  place TEXT,
  expense_date DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 지출 첨부 이미지
CREATE TABLE expense_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  expense_id UUID REFERENCES expenses(id) ON DELETE CASCADE,
  storage_path TEXT NOT NULL,
  is_receipt BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 월별 예산
CREATE TABLE budgets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID REFERENCES couples(id) NOT NULL,
  year_month TEXT NOT NULL,
  amount INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(couple_id, year_month)
);

-- 위시 저금통 목표
CREATE TABLE savings_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID REFERENCES couples(id) NOT NULL,
  created_by UUID REFERENCES users(id) NOT NULL,
  title TEXT NOT NULL,
  emoji TEXT NOT NULL DEFAULT '🎯',
  target_amount INT NOT NULL,
  current_amount INT NOT NULL DEFAULT 0,
  target_date DATE,
  priority TEXT NOT NULL DEFAULT 'medium'
    CHECK (priority IN ('high', 'medium', 'low')),
  status TEXT NOT NULL DEFAULT 'active'
    CHECK (status IN ('active', 'completed', 'cancelled')),
  description TEXT,
  image_path TEXT,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 저금 기록
CREATE TABLE savings_deposits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  goal_id UUID REFERENCES savings_goals(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) NOT NULL,
  amount INT NOT NULL CHECK (amount > 0),
  memo TEXT,
  deposited_at TIMESTAMPTZ DEFAULT now(),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 인덱스
CREATE INDEX idx_expenses_couple_date ON expenses(couple_id, expense_date DESC);
CREATE INDEX idx_expenses_user ON expenses(user_id);
CREATE INDEX idx_savings_goals_couple_status ON savings_goals(couple_id, status);
CREATE INDEX idx_savings_deposits_goal ON savings_deposits(goal_id, deposited_at DESC);

-- RLS 활성화
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE couples ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE savings_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE savings_deposits ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 지출
CREATE POLICY "own_expenses_crud" ON expenses
  USING (user_id = auth.uid());

CREATE POLICY "couple_expenses_read" ON expenses
  FOR SELECT USING (
    couple_id IN (SELECT couple_id FROM users WHERE id = auth.uid())
  );

-- RLS 정책: 예산
CREATE POLICY "couple_budgets" ON budgets
  USING (
    couple_id IN (SELECT couple_id FROM users WHERE id = auth.uid())
  );

-- RLS 정책: 저금통
CREATE POLICY "couple_savings_goals" ON savings_goals
  USING (
    couple_id IN (SELECT couple_id FROM users WHERE id = auth.uid())
  );

CREATE POLICY "couple_savings_deposits" ON savings_deposits
  USING (
    goal_id IN (
      SELECT id FROM savings_goals WHERE couple_id IN (
        SELECT couple_id FROM users WHERE id = auth.uid()
      )
    )
  );

-- 트리거: 저금 시 current_amount 자동 업데이트
CREATE OR REPLACE FUNCTION update_savings_goal_amount()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE savings_goals
  SET current_amount = (
    SELECT COALESCE(SUM(amount), 0) FROM savings_deposits WHERE goal_id = COALESCE(NEW.goal_id, OLD.goal_id)
  ),
  updated_at = now()
  WHERE id = COALESCE(NEW.goal_id, OLD.goal_id);

  -- 자동 완료 체크
  UPDATE savings_goals
  SET status = 'completed', completed_at = now()
  WHERE id = COALESCE(NEW.goal_id, OLD.goal_id)
    AND status = 'active'
    AND current_amount >= target_amount;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_savings_deposit_change
  AFTER INSERT OR DELETE ON savings_deposits
  FOR EACH ROW EXECUTE FUNCTION update_savings_goal_amount();
