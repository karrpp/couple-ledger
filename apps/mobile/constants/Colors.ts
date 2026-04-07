export const Colors = {
  primary: '#4A90D9',
  primaryLight: '#74B9FF',
  secondary: '#FFEAA7',
  coral: '#FF6B6B',
  background: '#F0F4F8',
  surface: '#FFFFFF',
  text: '#131D21',
  textSecondary: '#636E72',
  textMuted: '#B2BEC3',
  border: '#DFE6E9',
  success: '#00B894',
  warning: '#FDCB6E',
  danger: '#E17055',
  coupleA: '#4A90D9',
  coupleB: '#FF6B6B',
  tabInactive: '#B2BEC3',
};

export default {
  light: {
    text: Colors.text,
    background: Colors.background,
    tint: Colors.primary,
    tabIconDefault: Colors.tabInactive,
    tabIconSelected: Colors.primary,
  },
  dark: {
    text: '#fff',
    background: '#000',
    tint: Colors.primaryLight,
    tabIconDefault: '#666',
    tabIconSelected: Colors.primaryLight,
  },
};
