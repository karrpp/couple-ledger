export type GoalPriority = 'high' | 'medium' | 'low';
export type GoalStatus = 'active' | 'completed' | 'cancelled';

export interface SavingsGoal {
  id: string;
  couple_id: string;
  created_by: string;
  title: string;
  emoji: string;
  target_amount: number;
  current_amount: number;
  target_date: string | null;
  priority: GoalPriority;
  status: GoalStatus;
  description: string | null;
  image_path: string | null;
  completed_at: string | null;
  created_at: string;
  updated_at: string;
}

export interface SavingsDeposit {
  id: string;
  goal_id: string;
  user_id: string;
  amount: number;
  memo: string | null;
  deposited_at: string;
  created_at: string;
}

export interface CreateGoalInput {
  title: string;
  emoji: string;
  target_amount: number;
  target_date?: string;
  priority: GoalPriority;
  description?: string;
}

export interface CreateDepositInput {
  goal_id: string;
  amount: number;
  memo?: string;
}

export interface GoalSummary {
  id: string;
  title: string;
  emoji: string;
  progress_percent: number;
  current_amount: number;
  target_amount: number;
}
