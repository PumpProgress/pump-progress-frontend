import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_ai/ai_bloc.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';

class AiChatScaffold extends StatefulWidget {
  const AiChatScaffold({super.key, required this.title});

  final String title;

  @override
  State<AiChatScaffold> createState() => _AiChatScaffoldState();
}

class _AiChatScaffoldState extends State<AiChatScaffold> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<AiBloc, AiState>(
        builder: (context, state) {
          if (state.status is AiStatusInitial ||
              state.status is AiStatusInstalling) {
            return _buildLoadingBody(context, state);
          }
          if (state.status is AiStatusError) {
            return _buildErrorBody(context, state.status as AiStatusError);
          }
          return _buildChatBody(context, state);
        },
      ),
    );
  }

  Widget _buildLoadingBody(BuildContext context, AiState state) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 48, color: PPColors.amethyst300),
          const SizedBox(height: 16),
          Text('Getting AI ready…',
              style: Theme.of(context).textTheme.titleMedium),
          if (state.status is AiStatusInstalling) ...[
            const SizedBox(height: 8),
            Text(
              'Downloading model for the first time. This only happens once.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: PPColors.neutral300),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: state.downloadProgress / 100),
            const SizedBox(height: 8),
            Text(
              '${state.downloadProgress}%',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: PPColors.neutral300),
            ),
          ] else ...[
            const SizedBox(height: 24),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorBody(BuildContext context, AiStatusError status) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: PPColors.coral300),
          const SizedBox(height: 16),
          Text('Something went wrong',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            status.errorMsg,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: PPColors.neutral300),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<AiBloc>().add(const AiInitEvent()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBody(BuildContext context, AiState state) {
    return Column(
      children: [
        Expanded(child: _ChatMessageList(messages: state.messages)),
        _buildInputBar(context, state),
      ],
    );
  }

  Widget _buildInputBar(BuildContext context, AiState state) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: PPColors.neutral300.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                enabled: !state.isGenerating,
                decoration: const InputDecoration(
                  hintText: 'Type a message…',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: state.isGenerating
                  ? null
                  : () {
                      final text = _inputController.text.trim();
                      if (text.isEmpty) return;
                      context.read<AiBloc>().add(SendPromptEvent(text));
                      _inputController.clear();
                    },
              icon: const Icon(Icons.send),
              color: PPColors.amethyst300,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageList extends StatelessWidget {
  const _ChatMessageList({required this.messages});

  final List<ChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) => _ChatBubble(message: messages[index]),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final text = message.isStreaming ? '${message.text}…' : message.text;
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: message.isUser
              ? PPColors.amethyst400.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: PPColors.neutral300.withValues(alpha: 0.2),
          ),
        ),
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
