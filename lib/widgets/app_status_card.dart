import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:may_aegis/models/stat_item.dart';

class AppStatsCard extends StatelessWidget {
  final int totalApps;
  final Map<String, Map<String, dynamic>> permissionData;

  const AppStatsCard({
    required this.totalApps,
    required this.permissionData,
  });

  @override
  Widget build(BuildContext context) {
    int appsWithPermissions = permissionData.values
        .map((data) => (data['apps'] as List)
            .where((app) => app['hasPermission'] as bool)
            .length)
        .reduce((a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Statistics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  icon: Icons.apps,
                  label: 'Total Apps',
                  value: totalApps.toString(),
                ),
                StatItem(
                  icon: Icons.security,
                  label: 'With Permissions',
                  value: appsWithPermissions.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }
}