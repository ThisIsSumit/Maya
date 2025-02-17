import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final Map<String, double> _resourceUsage = {
    'Camera': 45,
    'Microphone': 30,
    'Location': 25,
  };

  final List<Map<String, dynamic>> _dailyUsage = [
    {
      'date': DateTime.now().subtract(const Duration(days: 13)),
      'camera': 12,
      'microphone': 8,
      'location': 5,
    },
    // Add more daily data here...
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics')
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 500))
            .slideX(begin: -0.2, end: 0),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Resource Usage Distribution', Icons.pie_chart)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 200))
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shadowColor: theme.shadowColor.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: _getChartSections(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ).animate().scale(
                          delay: const Duration(milliseconds: 400),
                          duration: const Duration(milliseconds: 500),
                        ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: _buildLegendItems(),
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 600),
                          duration: const Duration(milliseconds: 500),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionHeader('Daily Resource Usage', Icons.timeline)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 800))
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shadowColor: theme.shadowColor.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 5,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: theme.dividerColor,
                                strokeWidth: 0.5,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % 2 == 0) {
                                    final date = DateTime.now().subtract(
                                        Duration(days: (14 - value).toInt()));
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        DateFormat('MM/dd').format(date),
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      value.toInt().toString(),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineBarsData: _getLineChartData(),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ).animate().slideX(
                          delay: const Duration(milliseconds: 1000),
                          duration: const Duration(milliseconds: 500),
                        ),
                    const SizedBox(height: 16),
                    _buildLineChartLegend().animate().fadeIn(
                          delay: const Duration(milliseconds: 1200),
                          duration: const Duration(milliseconds: 500),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionHeader('Most Active Days', Icons.calendar_today)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 1200))
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 20),
            _buildMostActiveDaysList(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getChartSections() {
    // Camera (45%) - darkest, Microphone (30%) - medium, Location (25%) - lightest
    final List<Color> colors = [
      Colors.deepPurple.shade900, // Camera - most used
      Colors.deepPurple.shade700, // Microphone - medium usage
      Colors.deepPurple.shade500, // Location - least used
    ];

    return _resourceUsage.entries.map((entry) {
      final index = _resourceUsage.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        color: colors[index],
        value: entry.value,
        title: '${entry.value.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegendItems() {
    final List<Color> colors = [
      Colors.deepPurple.shade900, // Camera
      Colors.deepPurple.shade700, // Microphone
      Colors.deepPurple.shade500, // Location
    ];

    return _resourceUsage.entries.map((entry) {
      final index = _resourceUsage.keys.toList().indexOf(entry.key);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors[index].withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors[index].withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              entry.key,
              style: TextStyle(color: colors[index].withOpacity(0.8)),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<LineChartBarData> _getLineChartData() {
    // Using complementary colors for better visual distinction in the line chart
    final List<Color> colors = [
      Colors.teal.shade600, // Camera - vibrant teal
      Colors.amber.shade600, // Microphone - warm amber
      Colors.pink.shade400, // Location - soft pink
    ];

    final resources = ['camera', 'microphone', 'location'];

    return resources.map((resource) {
      final spots = _dailyUsage.asMap().entries.map((entry) {
        return FlSpot(
          entry.key.toDouble(),
          entry.value[resource].toDouble(),
        );
      }).toList();

      final color = colors[resources.indexOf(resource)];

      return LineChartBarData(
        spots: spots,
        color: color,
        barWidth: 3,
        isCurved: true, // Add smooth curves to the lines
        curveSmoothness: 0.3, // Adjust curve smoothness
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 4,
              color: color,
              strokeWidth: 2,
              strokeColor: Colors.white,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLineChartLegend() {
    final List<Color> colors = [
      Colors.teal.shade600,
      Colors.amber.shade600,
      Colors.pink.shade400,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: _resourceUsage.entries.map((entry) {
        final index = _resourceUsage.keys.toList().indexOf(entry.key);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors[index].withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors[index].withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.key,
                style: TextStyle(color: colors[index].withOpacity(0.8)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMostActiveDaysList(ThemeData theme) {
    return Card(
      elevation: 4,
      shadowColor: theme.shadowColor.withOpacity(0.2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.calendar_today,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(
              'March ${15 - index}, 2024',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              'Camera: 25 times, Microphone: 15 times, Location: 10 times',
              style: theme.textTheme.bodySmall,
            ),
          )
              .animate(delay: Duration(milliseconds: 1400 + (index * 100)))
              .fadeIn()
              .slideX();
        },
      ),
    );
  }
}
