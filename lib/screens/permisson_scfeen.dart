import 'package:flutter/material.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  List<Map<String, dynamic>> apps = [
    {'name': 'App 1', 'permission': 'Microphone', 'allowed': true},
    {'name': 'App 2', 'permission': 'Camera', 'allowed': false},
    {'name': 'App 3', 'permission': 'Location', 'allowed': true},
  ];

  String searchQuery = '';

  List<Map<String, dynamic>> get filteredApps {
    if (searchQuery.isEmpty) {
      return apps;
    }
    return apps
        .where((app) =>
            app['permission'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Permissions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Permission',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredApps.isEmpty
                ? Center(
                    child: Text(
                      'No apps found for "$searchQuery"',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = filteredApps[index];
                      return ListTile(
                        title: Text(app['name']),
                        subtitle: Text(app['permission']),
                        trailing: Switch(
                          value: app['allowed'],
                          onChanged: (value) {
                            setState(() {
                              app['allowed'] = value;
                            });
                            // Show feedback (snackbar)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${app['name']} permission ${value ? 'allowed' : 'disallowed'}'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}