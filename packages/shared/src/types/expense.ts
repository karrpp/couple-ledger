export interface Expense {
  id: string;
  user_id: string;
  couple_id: string;
  category_id: string;
  amount: number;
  memo: string | null;
  place: string | null;
  expense_date: string;
  created_at: string;
  updated_at: string;
}

export interface ExpenseImage {
  id: string;
  expense_id: string;
  storage_path: string;
  is_receipt: boolean;
  created_at: string;
}

export interface CreateExpenseInput {
  category_id: string;
  amount: number;
  memo?: string;
  place?: string;
  expense_date: string;
}
