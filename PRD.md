# 커플 가계부 앱 — PRD (Product Requirements Document)

**프로젝트명:** 커플 가계부 (가칭)
**작성일:** 2026-04-06
**버전:** v0.1

---

## 1. 제품 개요

둘이 함께 쓰는 커플 전용 가계부 앱. 각자 개인 지출을 입력하고, 합산된 전체 지출도 한눈에 확인 가능. 영수증/카드내역 사진을 첨부하면 자동으로 금액·날짜를 추출하고 카테고리까지 분류해주는 스마트 가계부.

### 핵심 가치
- **간편 입력**: 사진 한 장이면 끝 (OCR 자동 추출)
- **커플 시너지**: 각자 기록 → 합산 대시보드로 전체 재정 파악
- **예산 관리**: 월별 예산 설정 & 초과 알림
- **캘린더 뷰**: 날짜별 지출 흐름을 직관적으로 확인

---

## 2. 사용자 & 시나리오

### 타겟 유저
- 커플 (연인 2명이 한 팀)
- 각자 개인 기기에서 독립적으로 입력

### 핵심 시나리오

| # | 시나리오 | 설명 |
|---|---------|------|
| 1 | **빠른 수동 입력** | 금액, 카테고리, 메모 입력 → 저장 |
| 2 | **사진 OCR 입력** | 영수증/카드내역 사진 촬영 → 금액·날짜·카테고리 자동 추출 → 확인 후 저장 |
| 3 | **캘린더 확인** | 달력에서 날짜별 지출 총액 & 상세 내역 확인 |
| 4 | **대시보드 확인** | 월별 카테고리별 지출, 개인 vs 합산 비교, 예산 잔여 현황 |
| 5 | **커플 연결** | 초대코드로 파트너 연결 → 이후 서로의 지출 실시간 공유 |
| 6 | **예산 알림** | 월 예산 80% 도달 시 경고, 100% 초과 시 알림 |

---

## 3. 기능 명세

### 3.1 인증 & 커플 연결

| 항목 | 스펙 |
|------|------|
| 로그인 | 카카오 OAuth (Supabase Auth 연동) |
| 회원가입 | 카카오 로그인 시 자동 생성 |
| 커플 연결 | 6자리 초대코드 생성 → 파트너가 코드 입력 → 페어링 완료 |
| 연결 해제 | 설정에서 연결 해제 가능 (데이터는 각자 보존) |

### 3.2 지출 입력

**수동 입력 필드:**

| 필드 | 타입 | 필수 | 비고 |
|------|------|------|------|
| 금액 | number | ✅ | 원 단위 |
| 날짜 | date | ✅ | 기본값: 오늘 |
| 카테고리 | select | ✅ | 기본 프리셋 + 커스텀 |
| 메모 | text | ❌ | 자유 입력 |
| 장소 | text | ❌ | 선택적 입력 |
| 사진 | image | ❌ | 최대 3장, 영수증/추억 사진 |

**OCR 입력 플로우:**
1. 사진 촬영 or 갤러리 선택
2. Google Vision API → 텍스트 추출
3. 정규식(regex)으로 금액·날짜 파싱
4. 키워드 매칭 룰 기반 카테고리 자동 분류
5. 추출 결과 프리뷰 → 사용자 확인/수정 → 저장

### 3.3 카테고리 체계

**기본 프리셋 (수정/삭제 불가, 순서 변경 가능):**

| 아이콘 | 카테고리 | 매칭 키워드 예시 |
|--------|---------|----------------|
| 🍽️ | 식비 | 식당, 배달, 반찬 |
| ☕ | 카페 | 스타벅스, 투썸, 커피 |
| 🚌 | 교통 | 택시, 버스, 주유 |
| 🛍️ | 쇼핑 | 마트, 쿠팡, 이마트 |
| 🎬 | 문화/여가 | 영화, 넷플릭스, 공연 |
| 🏥 | 의료 | 약국, 병원, 의원 |
| 🏠 | 생활 | 공과금, 관리비, 통신 |
| 💰 | 기타 | 미분류 |

**커스텀 카테고리:** 사용자가 이름 + 아이콘(이모지) 설정하여 추가 가능

### 3.4 캘린더 뷰

- 월간 캘린더에 날짜별 총 지출 금액 표시
- 날짜 탭 → 해당일 상세 내역 리스트
- 내 지출 / 파트너 지출 / 합산 필터링
- 지출 없는 날 vs 있는 날 시각적 구분

### 3.5 대시보드

| 위젯 | 설명 |
|------|------|
| 월간 총 지출 | 이번 달 합산 금액 (개인/합산 토글) |
| 카테고리별 파이차트 | 비율 시각화 |
| 일별 지출 바차트 | 일별 추이 그래프 |
| 예산 프로그레스바 | 월 예산 대비 소진율 |
| 전월 대비 | 지난달 동일 시점 대비 증감 |
| Top 3 카테고리 | 가장 많이 쓴 카테고리 순위 |

### 3.6 예산 관리

| 항목 | 스펙 |
|------|------|
| 예산 설정 | 월별 총 예산 금액 설정 |
| 카테고리별 예산 | 선택적 (v2에서 추가 고려) |
| 알림 기준 | 80% 도달 시 경고, 100% 초과 시 알림 |
| 알림 방식 | 앱 내 알림 (푸시는 v2) |

### 3.7 사진 & 첨부

- 지출 건별 최대 3장 이미지 첨부
- 촬영 or 갤러리 선택
- Supabase Storage에 저장
- 썸네일 미리보기 지원

---

## 4. 기술 아키텍처

### 4.1 전체 스택

```
┌─────────────────────────────────────────────────┐
│                    클라이언트                      │
│                                                   │
│  React Native (Expo)     Next.js (Web)           │
│  - iOS / Android 앱      - 반응형 웹              │
│  - Expo Router           - App Router             │
│  - 카메라/갤러리 접근     - 데스크톱 대시보드       │
│                                                   │
├─────────────────────────────────────────────────┤
│                   백엔드 / BaaS                    │
│                                                   │
│  Supabase                                         │
│  ├─ Auth (카카오 OAuth)                           │
│  ├─ Database (PostgreSQL)                         │
│  ├─ Storage (이미지 저장)                          │
│  ├─ Realtime (커플 간 실시간 동기화)               │
│  └─ Edge Functions (OCR 처리)                     │
│                                                   │
├─────────────────────────────────────────────────┤
│                  외부 서비스                       │
│                                                   │
│  Google Vision API ─── OCR 텍스트 추출            │
│  Vercel ──────────── Next.js 호스팅               │
│  Expo EAS ─────────── 앱 빌드 & 배포              │
│                                                   │
└─────────────────────────────────────────────────┘
```

### 4.2 Database 스키마 (Supabase PostgreSQL)

```sql
-- 사용자
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  kakao_id TEXT UNIQUE NOT NULL,
  nickname TEXT NOT NULL,
  avatar_url TEXT,
  couple_id UUID REFERENCES couples(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 커플
CREATE TABLE couples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invite_code TEXT UNIQUE NOT NULL,       -- 6자리 초대코드
  user_a UUID REFERENCES users(id),
  user_b UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 카테고리
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID REFERENCES couples(id),  -- NULL이면 기본 프리셋
  name TEXT NOT NULL,
  icon TEXT NOT NULL,                     -- 이모지
  keywords TEXT[],                        -- OCR 매칭 키워드
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
  amount INT NOT NULL,                    -- 원 단위
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
  storage_path TEXT NOT NULL,             -- Supabase Storage 경로
  is_receipt BOOLEAN DEFAULT false,       -- 영수증 여부
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 월별 예산
CREATE TABLE budgets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  couple_id UUID REFERENCES couples(id) NOT NULL,
  year_month TEXT NOT NULL,               -- '2026-04' 형식
  amount INT NOT NULL,                    -- 월 예산 금액
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(couple_id, year_month)
);
```

### 4.3 OCR 처리 파이프라인

```
사진 업로드
    │
    ▼
Supabase Edge Function
    │
    ├─ Google Vision API 호출
    │   └─ 텍스트 블록 추출
    │
    ├─ 정규식 파싱
    │   ├─ 금액: /[\d,]+원/ 또는 /합계.*[\d,]+/
    │   ├─ 날짜: /\d{4}[-./]\d{2}[-./]\d{2}/
    │   └─ 상호명: 첫 줄 또는 사업자 정보
    │
    ├─ 카테고리 매칭
    │   └─ 키워드 테이블 기반 룰 매칭
    │       (스타벅스 → 카페, 이마트 → 쇼핑 등)
    │
    └─ 결과 반환
        { amount, date, category_id, place, confidence }
```

### 4.4 커플 연결 플로우

```
User A: 회원가입 → couples 레코드 생성 → 초대코드 발급
                                            │
                                      코드 공유 (카톡 등)
                                            │
User B: 회원가입 → 초대코드 입력 → couples.user_b에 등록
                                            │
                                  양쪽 users.couple_id 업데이트
                                            │
                                    Realtime 구독 시작 ✅
```

### 4.5 Supabase RLS (Row Level Security)

```sql
-- 내 지출만 CRUD 가능
CREATE POLICY "own_expenses" ON expenses
  USING (user_id = auth.uid());

-- 같은 커플의 지출은 조회 가능
CREATE POLICY "couple_expenses_read" ON expenses
  FOR SELECT USING (
    couple_id IN (
      SELECT couple_id FROM users WHERE id = auth.uid()
    )
  );

-- 예산은 같은 커플만
CREATE POLICY "couple_budgets" ON budgets
  USING (
    couple_id IN (
      SELECT couple_id FROM users WHERE id = auth.uid()
    )
  );
```

---

## 5. 프로젝트 구조

```
couple-ledger/
├── apps/
│   ├── mobile/                  # Expo (React Native)
│   │   ├── app/                 # Expo Router 파일 기반 라우팅
│   │   │   ├── (auth)/          # 로그인 화면
│   │   │   ├── (tabs)/          # 메인 탭 네비게이션
│   │   │   │   ├── calendar.tsx
│   │   │   │   ├── dashboard.tsx
│   │   │   │   ├── add.tsx      # 지출 입력
│   │   │   │   └── settings.tsx
│   │   │   └── _layout.tsx
│   │   ├── components/
│   │   ├── hooks/
│   │   └── utils/
│   │
│   └── web/                     # Next.js
│       ├── app/
│       │   ├── page.tsx         # 랜딩/로그인
│       │   ├── dashboard/
│       │   ├── calendar/
│       │   └── settings/
│       ├── components/
│       └── utils/
│
├── packages/
│   └── shared/                  # 공유 로직
│       ├── supabase/            # Supabase 클라이언트 & 타입
│       ├── types/               # TypeScript 타입 정의
│       ├── utils/               # 공통 유틸 (날짜, 금액 포맷 등)
│       └── ocr/                 # OCR 파싱 로직
│
└── supabase/
    ├── migrations/              # DB 마이그레이션
    ├── functions/               # Edge Functions
    │   └── ocr-process/         # OCR 처리 함수
    └── seed.sql                 # 기본 카테고리 시드 데이터
```

---

## 6. 비용 산정 (월 기준, 커플 1팀)

| 항목 | 무료 한도 | 예상 사용량 | 예상 비용 |
|------|----------|-----------|----------|
| Supabase | Free tier (500MB DB, 1GB Storage) | 충분 | $0 |
| Vercel | Free tier (Hobby) | 충분 | $0 |
| Expo EAS | Free tier (빌드 30회/월) | 충분 | $0 |
| Google Vision API | 1,000건/월 무료 | ~100건/월 | $0 |
| 카카오 로그인 | 무료 | - | $0 |
| **합계** | | | **$0/월** |

> 사용자 확대 시 Supabase Pro ($25/월) + Vercel Pro ($20/월) 전환 필요. 구독 모델로 충당 계획.

---

## 7. 개발 로드맵

### Phase 1 — MVP (4~6주)
- [ ] Supabase 셋업 (DB, Auth, Storage)
- [ ] 카카오 OAuth 연동
- [ ] 커플 초대코드 연결
- [ ] 수동 지출 입력 CRUD
- [ ] 캘린더 뷰 (월간)
- [ ] 기본 대시보드 (월간 총액, 카테고리 파이차트)
- [ ] Expo 앱 기본 빌드

### Phase 2 — 스마트 기능 (3~4주)
- [ ] OCR 사진 입력 (Google Vision + 정규식 파싱)
- [ ] 카테고리 자동 분류 (키워드 매칭)
- [ ] 예산 설정 & 알림
- [ ] 커스텀 카테고리 추가
- [ ] Next.js 웹 버전

### Phase 3 — 고도화 (지속)
- [ ] 푸시 알림 (Expo Notifications)
- [ ] 카테고리별 예산
- [ ] 전월 대비 분석 리포트
- [ ] Claude API 연동 (스마트 카테고리 분류 업그레이드)
- [ ] 구독 모델 도입 (사용자 확대 시)
- [ ] 네이버 지도 연동 (장소 자동완성)

---

## 8. 주요 기술 결정 사항 요약

| 결정 사항 | 선택 | 이유 |
|----------|------|------|
| 프론트엔드 (앱) | React Native + Expo | iOS/Android 동시 배포, Expo EAS로 빌드 간소화 |
| 프론트엔드 (웹) | Next.js | Vercel 배포, SSR/SEO, 반응형 대시보드 |
| 백엔드 | Supabase | Auth + DB + Storage + Realtime 올인원, Free tier 충분 |
| 호스팅 | Vercel (웹) + Expo EAS (앱) | 무료 티어 활용 |
| 인증 | 카카오 OAuth via Supabase Auth | 한국 사용자 접근성 |
| OCR | Google Vision API | 월 1,000건 무료, 한국어 지원 |
| 카테고리 분류 | 키워드 룰 기반 (Phase 1) → Claude API (Phase 3) | 초기 $0 운영, 점진적 AI 고도화 |
| DB | PostgreSQL (Supabase) | RLS, Realtime, 타입 안전성 |
| 모노레포 | apps/mobile + apps/web + packages/shared | 코드 재사용 극대화 |
