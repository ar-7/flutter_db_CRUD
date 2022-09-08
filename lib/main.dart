// Importing packages
import 'package:flutter/material.dart';
import 'data_table_ui.dart';

// Run function for the app
void main() {
  runApp(const MyApp());
}

// Class defining the application attributes
class MyApp extends StatelessWidget {
  const MyApp({Key? key})
      : super(key: key); // Creating the unique key for the element
  @override
  Widget build(BuildContext context) {
    // Using default material UI for the app
    return MaterialApp(
      title: 'Flutter Research App',
      theme: ThemeData(
        // Theme configuration for the application
        primarySwatch: Colors.blue, // Default material blue
      ),
      home:
          const DataTableUI(), // Calling the functionality from an outside class
    );
  }
}
