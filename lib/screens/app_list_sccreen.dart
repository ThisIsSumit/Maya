import 'package:flutter/material.dart';

class AppListScreen extends StatelessWidget {
  final String resource;
  final List<String> apps;

  const AppListScreen({Key? key, required this.resource, required this.apps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apps Using $resource')),
      body: ListView.builder(
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