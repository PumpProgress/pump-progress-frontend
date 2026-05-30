// lib/screens/ai/models/view/models_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pump_progress_frontend/features/ai/blocs/bloc_model_manager/model_manager_bloc.dart';
import 'package:pump_progress_frontend/utils/helpers/format_bytes.dart';

class ModelsView extends StatelessWidget {
  const ModelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Models')),
      body: BlocBuilder<ModelManagerBloc, ModelManagerState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) =>
                      _ModelTile(item: state.items[index]),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Total on disk: ${formatBytes(state.totalDiskBytes)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModelTile extends StatelessWidget {
  const _ModelTile({required this.item});

  final ModelItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.model.displayName),
      subtitle: Text(
        '${item.model.description} · ${formatBytes(item.model.sizeBytes)}',
      ),
      trailing: _buildTrailing(context),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    final bloc = context.read<ModelManagerBloc>();

    switch (item.state) {
      case ModelDownloadState.notDownloaded:
        return ElevatedButton(
          onPressed: () => bloc.add(DownloadModel(item.model)),
          child: const Text('Download'),
        );
      case ModelDownloadState.downloading:
        return SizedBox(
          width: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: item.progress / 100),
              const SizedBox(height: 4),
              Text('${item.progress}%'),
            ],
          ),
        );
      case ModelDownloadState.downloaded:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.isActive)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text('Active',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            else
              TextButton(
                onPressed: () => bloc.add(SelectModel(item.model)),
                child: const Text('Use'),
              ),
            TextButton(
              onPressed: () => _confirmDelete(context, bloc),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
    }
  }

  void _confirmDelete(BuildContext context, ModelManagerBloc bloc) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete model'),
        content: Text('Delete ${item.model.displayName} from this device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              bloc.add(DeleteModel(item.model));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
