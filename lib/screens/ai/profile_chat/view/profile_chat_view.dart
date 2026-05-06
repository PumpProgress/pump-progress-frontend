import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_ai/ai_bloc.dart';

class ProfileChatView extends StatefulWidget {
  const ProfileChatView({super.key});

  @override
  State<ProfileChatView> createState() => _ProfileChatViewState();
}

class _ProfileChatViewState extends State<ProfileChatView> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: BlocBuilder<AiBloc, AiState>(
        builder: (context, state) {
          if (state.status is AiStatusInitial ||
              state.status is AiStatusInstalling) {
            return _buildLoadingBody(context, state.status);
          }
          if (state.status is AiStatusError) {
            return _buildErrorBody(context, state.status as AiStatusError);
          }
          return _buildChatBody(context);
        },
      ),
    );
  }

  Widget _buildLoadingBody(BuildContext context, AiStatus status) {
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
          if (status is AiStatusInstalling) ...[
            const SizedBox(height: 8),
            Text(
              'Downloading model for the first time. This only happens once.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: PPColors.neutral300),
            ),
          ],
          const SizedBox(height: 24),
          const LinearProgressIndicator(),
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
            onPressed: () =>
                context.read<AiBloc>().add(const AiInitEvent()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBody(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: _ChatMessageList(),
        ),
        _buildInputBar(context),
      ],
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
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
              decoration: const InputDecoration(
                hintText: 'Type a message…',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
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
    );
  }
}

class _ChatMessageList extends StatelessWidget {
  const _ChatMessageList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [],
    );
  }
}
