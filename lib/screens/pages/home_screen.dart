import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  // Dummy data for resource usage
  final Map<String, double> resourceUsage = {
    'Microphone': 40,
    'Camera': 30,
    'Location': 30,
  };

  // Dummy data for apps using each resource
  final Map<String, List<String>> appsUsingResource = {
    'Microphone': ['App A', 'App B', 'App C'],
    'Camera': ['App D', 'App E'],
    'Location': ['App F', 'App G', 'App H'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Usage'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: _buildPieChartSections(context),
                centerSpaceRadius: 50,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tap a section to see apps using that resource',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(BuildContext context) {
    return resourceUsage.entries.map((entry) {
      final resource = entry.key;
      final percentage = entry.value;
      final color = _getColorForResource(resource);

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '$percentage%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _buildBadge(context, resource, color),
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  Widget _buildBadge(BuildContext context, String resource, Color color) {
    return GestureDetector(
      onTap: () => _navigateToAppList(context, resource),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Text(
          resource[0], // Display the first letter of the resource
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToAppList(BuildContext context, String resource) {
    final apps = appsUsingResource[resource] ?? [];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppListScreen(resource: resource, apps: apps),
      ),
    );
  }

  Color _getColorForResource(String resource) {
    switch (resource) {
      case 'Microphone':
        return Colors.blue;
      case 'Camera':
        return Colors.green;
      case 'Location':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class AppListScreen extends StatelessWidget {
  final String resource;
  final List<String> apps;

  const AppListScreen({Key? key, required this.resource, required this.apps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apps Using $resource'),
      ),
      body: apps.isEmpty
          ? const Center(
              child: Text(
                'No apps found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: apps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(apps[index]),
                  leading: const Icon(Icons.apps),
                );
              },
            ),
    );
  }
}
