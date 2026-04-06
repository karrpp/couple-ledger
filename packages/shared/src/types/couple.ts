export interface User {
  id: string;
  kakao_id: string;
  nickname: string;
  avatar_url: string | null;
  couple_id: string | null;
  created_at: string;
}

export interface Couple {
  id: string;
  invite_code: string;
  user_a: string | null;
  user_b: string | null;
  created_at: string;
}
