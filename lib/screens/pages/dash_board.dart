import 'package:flutter/material.dart';
import 'package:may_aegis/screens/permisson_scfeen.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Controller'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          DashboardItem(
            icon: Icons.security,
            title: 'Permissions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PermissionScreen()),
              );
            },
          ),
          // Add more dashboard items here
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DashboardItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
