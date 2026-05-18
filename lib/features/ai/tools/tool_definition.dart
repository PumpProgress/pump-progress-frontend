import 'package:flutter_gemma/flutter_gemma.dart';

class ToolDefinition {
  const ToolDefinition({
    required this.tool,
    required this.messageBuilder,
    required this.handler,
  });

  final Tool tool;
  final String Function(Map<String, dynamic> args) messageBuilder;
  final Future<Map<String, dynamic>> Function(Map<String, dynamic> args) handler;
}
