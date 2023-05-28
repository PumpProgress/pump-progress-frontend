import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pump_progress_frontend/repositories/models/series.dart';

class SetsList extends StatelessWidget {
  const SetsList({super.key, required this.sets});

  final List<Series> sets;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: sets.length,
        itemBuilder: (context, index) {
          final series = sets[index];

          final formattedDate =
              DateFormat.yMMMd().add_Hm().format(series.createdAt);
          // return ListTile(
          //   title: Text('${sets[index]}'),
          // );
          return ListTile(
            title: Text('Weight: ${series.weight}'),
            subtitle: Text('Reps: ${series.repetitions}\nDate: $formattedDate'),
          );
        },
      ),
    );
  }
}
