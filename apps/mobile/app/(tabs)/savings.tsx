import { StyleSheet, Text, View } from 'react-native';
import { Colors } from '@/constants/Colors';

export default function SavingsScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.emoji}>🐷</Text>
      <Text style={styles.title}>위시 저금통</Text>
      <Text style={styles.subtitle}>커플 저축 목표 관리 (구현 예정)</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
    alignItems: 'center',
    justifyContent: 'center',
  },
  emoji: {
    fontSize: 48,
    marginBottom: 12,
  },
  title: {
    fontSize: 24,
    fontWeight: '700',
    color: Colors.text,
  },
  subtitle: {
    fontSize: 14,
    color: Colors.textSecondary,
    marginTop: 8,
  },
});
