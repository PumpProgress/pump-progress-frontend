// lib/screens/ai/widgets/ai_chat_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_chat/chat_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_gemma_model/gemma_model_bloc.dart';
import 'package:pump_progress_frontend/features/ai/domain/domain.dart';
import 'package:pump_progress_frontend/screens/ai/models/models_page.dart';

class AiChatScaffold<B extends BaseChatBloc> extends StatefulWidget {
  const AiChatScaffold({super.key, required this.title});

  final String title;

  @override
  State<AiChatScaffold<B>> createState() => _AiChatScaffoldState<B>();
}

class _AiChatScaffoldState<B extends BaseChatBloc>
    extends State<AiChatScaffold<B>> {
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
      body: BlocBuilder<GemmaModelBloc, GemmaModelState>(
        builder: (context, modelState) {
          if (modelState.status is GemmaModelStatusInitial ||
              modelState.status is GemmaModelStatusLoading) {
            return _buildLoadingBody(context);
          }
          if (modelState.status is GemmaModelStatusNoModel) {
            return _buildNoModelBody(context);
          }
          if (modelState.status is GemmaModelStatusError) {
            return _buildErrorBody(
              context,
              modelState.status as GemmaModelStatusError,
            );
          }
          return BlocBuilder<B, ChatState>(
            builder: (context, chatState) {
              if (chatState.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to start chat: ${chatState.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (!chatState.isReady) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildChatBody(context, chatState);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 48, color: PPColors.amethyst300),
          const SizedBox(height: 16),
          Text('Getting AI ready…',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          const LinearProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildNoModelBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.download_for_offline,
              size: 48, color: PPColors.amethyst300),
          const SizedBox(height: 16),
          Text('No AI model installed',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Download a model to start chatting.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: PPColors.neutral300),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, ModelsPage.routeName),
            child: const Text('Manage models'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBody(BuildContext context, GemmaModelStatusError status) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            onPressed: () => context
                .read<GemmaModelBloc>()
                .add(const GemmaModelInitEvent()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBody(BuildContext context, ChatState state) {
    return Column(
      children: [
        Expanded(child: _ChatMessageList(messages: state.messages)),
        _buildInputBar(context, state.isGenerating),
      ],
    );
  }

  Widget _buildInputBar(BuildContext context, bool isGenerating) {
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
                enabled: !isGenerating,
                decoration: const InputDecoration(
                  hintText: 'Type a message…',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: isGenerating
                  ? null
                  : () {
                      final text = _inputController.text.trim();
                      if (text.isEmpty) return;
                      context.read<B>().add(SendMessageEvent(text));
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
      return const Center(child: Text('Start a conversation'));
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
    if (message.isSystemMessage) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: PPColors.amethyst400.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction,
                  size: 12, color: PPColors.neutral300),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PPColors.neutral300,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final text = message.isStreaming ? '${message.text}…' : message.text;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
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
        child: message.isUser
            ? Text(text, style: bodyStyle)
            : MarkdownBody(
                data: text,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(p: bodyStyle),
              ),
      ),
    );
  }
}
