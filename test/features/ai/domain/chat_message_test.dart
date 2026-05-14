import 'package:flutter_test/flutter_test.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';

void main() {
  group('ChatMessage', () {
    const base = ChatMessage(text: 'Hello', isUser: true);

    test('props include text, isUser, isStreaming', () {
      expect(base.props, equals(['Hello', true, false]));
    });

    test('copyWith updates text', () {
      final updated = base.copyWith(text: 'Hi');
      expect(updated.text, 'Hi');
      expect(updated.isUser, true);
      expect(updated.isStreaming, false);
    });

    test('copyWith updates isStreaming', () {
      final updated = base.copyWith(isStreaming: true);
      expect(updated.isStreaming, true);
      expect(updated.text, 'Hello');
    });

    test('copyWith does not change isUser', () {
      final updated = base.copyWith(text: 'new');
      expect(updated.isUser, true);
    });

    test('equality holds when props match', () {
      const a = ChatMessage(text: 'x', isUser: false);
      const b = ChatMessage(text: 'x', isUser: false);
      expect(a, equals(b));
    });

    test('equality fails when props differ', () {
      const a = ChatMessage(text: 'x', isUser: true);
      const b = ChatMessage(text: 'x', isUser: false);
      expect(a, isNot(equals(b)));
    });
  });
}
