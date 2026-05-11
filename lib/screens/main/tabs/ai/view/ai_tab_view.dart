import 'package:flutter/material.dart';
import 'package:pump_progress_frontend/config/theme/colors.dart';

class AiTabView extends StatelessWidget {
  const AiTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose what you\'d like to do.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: PPColors.neutral300),
          ),
          const SizedBox(height: 20),
          _ModeCard(
            icon: Icons.person_outline,
            title: 'Complete Profile',
            subtitle: 'Chat to fill in your personal info, goals & preferences',
            routeName: '/ai/profile-chat',
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.fitness_center,
            title: 'Build Workout',
            subtitle: 'Chat to generate a workout plan tailored to you',
            routeName: '/ai/workout-builder',
          ),
          const SizedBox(height: 12),
          const _ComingSoonCard(),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routeName,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PPColors.neutral300.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: PPColors.amethyst400.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: PPColors.amethyst300),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PPColors.neutral300,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: PPColors.amethyst300),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: PPColors.neutral300.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: PPColors.neutral400.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: PPColors.neutral300),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Coming Soon',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    'More AI features on the way',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PPColors.neutral300,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
