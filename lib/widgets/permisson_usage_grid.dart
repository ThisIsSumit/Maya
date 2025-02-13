import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PermissionUsageGrid extends StatelessWidget {
  final Map<String, Map<String, dynamic>> permissionData;
  final Function(String) onAppTap;

  const PermissionUsageGrid({
    required this.permissionData,
    required this.onAppTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: permissionData.length,
      itemBuilder: (context, index) {
        final entry = permissionData.entries.elementAt(index);
        final data = entry.value;
        final apps = data['apps'] as List;
        
        return Card(
          child: InkWell(
            onTap: () {
              // TODO: Navigate to permission details
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(data['icon'] as IconData, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    data['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${apps.length} apps',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: (index * 100).ms).slideY();
      },
    );
  }
}