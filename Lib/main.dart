import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(const RowEdgeApp());
}

class RowEdgeApp extends StatelessWidget {
  const RowEdgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Row Edge',
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}
