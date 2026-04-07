import { StyleSheet, Text, View } from 'react-native';
import { Colors } from '@/constants/Colors';

export default function AddExpenseScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>지출 추가</Text>
      <Text style={styles.subtitle}>금액, 카테고리, 메모 입력 (구현 예정)</Text>
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
