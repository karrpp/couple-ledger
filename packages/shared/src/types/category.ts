export interface Category {
  id: string;
  couple_id: string | null;
  name: string;
  icon: string;
  keywords: string[];
  sort_order: number;
  is_default: boolean;
  created_at: string;
}

export const DEFAULT_CATEGORIES = [
  { icon: '🍽️', name: '식비', keywords: ['식당', '배달', '반찬'] },
  { icon: '☕', name: '카페', keywords: ['스타벅스', '투썸', '커피'] },
  { icon: '🚌', name: '교통', keywords: ['택시', '버스', '주유'] },
  { icon: '🛍️', name: '쇼핑', keywords: ['마트', '쿠팡', '이마트'] },
  { icon: '🎬', name: '문화/여가', keywords: ['영화', '넷플릭스', '공연'] },
  { icon: '🏥', name: '의료', keywords: ['약국', '병원', '의원'] },
  { icon: '🏠', name: '생활', keywords: ['공과금', '관리비', '통신'] },
  { icon: '💰', name: '기타', keywords: [] },
] as const;
