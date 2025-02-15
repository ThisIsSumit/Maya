import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:may_aegis/widgets/app_status_card.dart';
import 'package:may_aegis/widgets/permisson_usage_grid.dart';
import 'package:may_aegis/widgets/recent_activity_list_widget.dart';
import 'package:may_aegis/widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel('com.example.permission_manager/permissions');

  final Map<String, Map<String, dynamic>> _permissionData = {
    'android.permission.CAMERA': {
      'icon': Icons.camera_alt,
      'name': 'Camera',
      'apps': <Map<String, dynamic>>[],
    },
    'android.permission.RECORD_AUDIO': {
      'icon': Icons.mic,
      'name': 'Microphone',
      'apps': <Map<String, dynamic>>[],
    },
    'android.permission.ACCESS_FINE_LOCATION': {
      'icon': Icons.location_on,
      'name': 'Location',
      'apps': <Map<String, dynamic>>[],
    },
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPermissionData();
  }

  Future<void> _loadPermissionData() async {
    setState(() => _isLoading = true);

    try {
      for (final permissionType in _permissionData.keys) {
        final List<dynamic> apps = await platform.invokeMethod(
          'getAppsWithPermission',
          {'permission': permissionType},
        );

        // Ensure the apps are cast correctly
        setState(() {
          _permissionData[permissionType]?['apps'] = List<Map<String, dynamic>>.from(
            apps.map((app) => Map<String, dynamic>.from(app))
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading permission data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openAppSettings(String packageName) async {
    try {
      await platform.invokeMethod('openAppSettings', {'packageName': packageName});
    } catch (e) {
      debugPrint('Error opening app settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    int totalApps = _permissionData.values
        .map((data) => (data['apps'] as List).length)
        .reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPermissionData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPermissionData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStatsCard(
                totalApps: totalApps,
                permissionData: _permissionData,
              ),
              const SizedBox(height: 20),
              SectionTitle('Permission Usage'),
              const SizedBox(height: 10),
              PermissionUsageGrid(
                permissionData: _permissionData,
                onAppTap: _openAppSettings,
              ),
              const SizedBox(height: 20),
              SectionTitle('Recent Permission Changes'),
              const SizedBox(height: 10),
              RecentActivityList(
                permissionData: _permissionData,
                onAppTap: _openAppSettings,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.apps),
            label: 'Permissions',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
        onDestinationSelected: (index) {
          // TODO: Implement navigation
        },
      ),
    );
  }
}
