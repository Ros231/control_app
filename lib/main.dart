import 'package:control_app/pages/Control.dart';
import 'package:flutter/material.dart';

  void main() {
    runApp(Control());
  }
class Control extends StatefulWidget {
  const new({super.key});

  @override

  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control App',
      home:ButtonControl(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}