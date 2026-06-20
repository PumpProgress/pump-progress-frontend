class ResolvedToolUse {
  const ResolvedToolUse({required this.message, required this.execute});

  final String message;
  final Future<Map<String, dynamic>> Function() execute;
}
