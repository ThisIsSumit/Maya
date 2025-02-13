import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecentActivityList extends StatelessWidget {
  final Map<String, Map<String, dynamic>> permissionData;
  final Function(String) onAppTap;

  const RecentActivityList({
    required this.permissionData,
    required this.onAppTap,
  });

  @override
  Widget build(BuildContext context) {
    final allApps = permissionData.values
        .expand((data) => (data['apps'] as List))
        .toList()
      ..sort((a, b) => (b['lastAccessed'] ?? 0).compareTo(a['lastAccessed'] ?? 0));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allApps.length.clamp(0, 5),
      itemBuilder: (context, index) {
        final app = allApps[index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.android),  // Placeholder since we don't have icons
            ),
            title: Text(app['appName'] as String),
            subtitle: Text(app['packageName'] as String),
            onTap: () => onAppTap(app['packageName'] as String),
          ),
        ).animate().fadeIn(delay: (index * 100).ms).slideX();
      },
    );
  }
}

