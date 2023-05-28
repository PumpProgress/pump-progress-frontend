import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExerciseTrackerWidget extends StatefulWidget {
  @override
  _ExerciseTrackerWidgetState createState() => _ExerciseTrackerWidgetState();
}

class _ExerciseTrackerWidgetState extends State<ExerciseTrackerWidget> {
  List<ExerciseEntry> exercises = [];

  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  void _saveExercise() {
    String weight = weightController.text;
    String reps = repsController.text;
    DateTime now = DateTime.now();

    ExerciseEntry exercise = ExerciseEntry(
      weight: weight,
      reps: reps,
      date: now,
    );

    setState(() {
      exercises.insert(0, exercise);
    });
  }

  Widget _buildExerciseList() {
    return Expanded(
      child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          ExerciseEntry exercise = exercises[index];
          String formattedDate =
              DateFormat.yMMMd().add_Hm().format(exercise.date);

          return ListTile(
            title: Text('Weight: ${exercise.weight}'),
            subtitle: Text('Reps: ${exercise.reps}\nDate: $formattedDate'),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: repsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Reps',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _saveExercise();
                          Navigator.pop(context);
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Text('Add Exercise'),
        ),
        _buildExerciseList(),
      ],
    );
  }
}

class ExerciseEntry {
  final String weight;
  final String reps;
  final DateTime date;

  ExerciseEntry({
    required this.weight,
    required this.reps,
    required this.date,
  });
}
