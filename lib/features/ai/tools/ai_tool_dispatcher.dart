import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:meta/meta.dart';
import 'package:pump_progress_frontend/features/ai/tools/resolved_tool_use.dart';
import 'package:pump_progress_frontend/features/ai/tools/tool_definition.dart';

/// Base class for chat tool dispatchers. A dispatcher owns a set of
/// [ToolDefinition]s, exposes their [Tool]s to the model, and resolves an
/// incoming [FunctionCallResponse] into an executable [ResolvedToolUse].
///
/// Subclasses populate [definitions] inside [init]; [init] is awaited by the
/// chat bloc before the first message.
abstract class AiToolDispatcher {
  @protected
  List<ToolDefinition> definitions = [];

  /// Builds the tool [definitions]. Must be called before accessing [tools].
  Future<void> init();

  List<Tool> get tools {
    assert(definitions.isNotEmpty,
        'AiToolDispatcher.init() must be called before accessing tools');
    return definitions.map((d) => d.tool).toList();
  }

  ResolvedToolUse resolve(FunctionCallResponse call) {
    final def = _definitionFor(call.name);
    return ResolvedToolUse(
      message: def.messageBuilder(call.args),
      execute: () => def.handler(call.args),
    );
  }

  ToolDefinition _definitionFor(String name) => definitions.firstWhere(
        (d) => d.tool.name == name,
        orElse: () => throw StateError('Unknown tool: $name'),
      );
}
