import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:may_aegis/screens/app_list_sccreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy data for resource usage
  final Map<String, double> resourceUsage = {
    'Microphone': 40,
    'Camera': 30,
    'Location': 30,
  };

  // Dummy data
  final Map<String, List<String>> appsUsingResource = {
    'Microphone': ['App A', 'App B', 'App C'],
    'Camera': ['App D', 'App E'],
    'Location': ['App F', 'App G', 'App H'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resource Usage')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(),
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Tap on a section to see apps using that resource',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return resourceUsage.entries.map((entry) {
      final resource = entry.key;
      final percentage = entry.value;
      final color = _getColorForResource(resource);

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '$percentage%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _buildBadge(resource, color),
        badgePositionPercentageOffset: 1.1,
      );
    }).toList();
  }

  Widget _buildBadge(String resource, Color color) {
    return GestureDetector(
      onTap: () {
        _navigateToAppList(resource);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Text(
          resource, // Display the first letter of the resource
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToAppList(String resource) {
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


