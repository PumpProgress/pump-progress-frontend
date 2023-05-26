import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  final String exerciseName;
  final List<String> muscles;
  final bool isLiked;
  final Function(bool)? onLikeToggle;

  ExerciseWidget({
    required this.exerciseName,
    required this.muscles,
    required this.isLiked,
    this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          exerciseName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 4.0,
            runSpacing: -8.0,
            children: muscles
                .map(
                  (muscle) => Chip(
                    label: Text(
                      muscle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: _getColorForMuscle(muscle),
                  ),
                )
                .toList(),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          onPressed:
              onLikeToggle != null ? () => onLikeToggle!(!isLiked) : null,
        ),
      ),
    );
  }

  Color _getColorForMuscle(String muscle) {
    final bluePalette = [
      Colors.blue[400],
      Colors.blue[600],
      Colors.blue[800],
    ];

    final greyPalette = [
      Colors.grey[400],
      Colors.grey[600],
      Colors.grey[800],
    ];

    final index = muscle.length % bluePalette.length;
    return index % 2 == 0 ? bluePalette[index ~/ 2]! : greyPalette[index ~/ 2]!;
  }
}
