import type { GoalPriority, SavingsDeposit } from '../types/savings';

export function calcProgressPercent(current: number, target: number): number {
  if (target <= 0) return 0;
  return Math.min(100, Math.round((current / target) * 1000) / 10);
}

export function calcDailyTarget(remaining: number, daysLeft: number): number {
  if (daysLeft <= 0) return remaining;
  return Math.ceil(remaining / daysLeft);
}

export function getPriorityConfig(priority: GoalPriority) {
  const map = {
    high: { label: '높음', emoji: '🔥', color: '#FF6B6B' },
    medium: { label: '보통', emoji: '⭐', color: '#FFEAA7' },
    low: { label: '낮음', emoji: '💤', color: '#B2BEC3' },
  } as const;
  return map[priority];
}

export function calcContributionSplit(
  deposits: SavingsDeposit[],
  userAId: string,
  userBId: string,
) {
  let userA = 0;
  let userB = 0;
  for (const d of deposits) {
    if (d.user_id === userAId) userA += d.amount;
    else if (d.user_id === userBId) userB += d.amount;
  }
  return { userA, userB };
}
