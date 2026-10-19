import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ButtonControl extends StatefulWidget {
  const ButtonControl({super.key});

  @override
  State<ButtonControl> createState() => _ButtonControlState();
}

class _ButtonControlState extends State<ButtonControl> {
  
  Future<void> sendCommand(String gear, String command) async {
    final url = Uri.parse('http://100.101.22.78:8000/control/$gear/$command');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        debugPrint('Command sent: $gear | $command');
      } else {
        debugPrint('Failed to send command: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending command: $e');
    }
  }

  String gear = 'gear1';

  Widget _buildArrowButton({
    required IconData icon,
    required String command,
    required String tooltip,
    required String gear,
  }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: () => sendCommand(gear, command),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          fixedSize: const Size(72, 72),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.blueAccent.withValues(alpha: 0.4),
          padding: EdgeInsets.zero,
        ),
        child: Icon(icon, size: 36),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control App'),
        centerTitle: true,
      ),  
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Gear selection
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(onPressed : () {
                    setState(() {
                      gear = 'gear1';
                    });
                  }, child: Text('Gear 1', style: TextStyle(color: gear == 'gear1' ? Colors.white : Colors.black))),
                  const SizedBox(width: 16),
                  ElevatedButton(onPressed : () {
                    setState(() {
                      gear = 'gear2';
                    });
                  }, child: Text('Gear 2', style: TextStyle(color: gear == 'gear2' ? Colors.white : Colors.black))),  
                ],
              ),
  
                  

              // Forward
              _buildArrowButton(
                icon: Icons.arrow_upward_rounded,
                command: 'forward',
                tooltip: 'Forward',
                gear: gear,
              ),
              const SizedBox(height: 16),
              // Left & Right
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildArrowButton(
                    icon: Icons.arrow_back_rounded,
                    command: 'left',
                    tooltip: 'Left',
                    gear: gear,
                  ),

                  const SizedBox(width: 16),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: _buildArrowButton(
                      icon: Icons.stop_rounded,
                      command: 'stop',
                      tooltip: 'Stop',
                      gear: gear,
                    ),
                  ),

                  const SizedBox(width: 16),
                  _buildArrowButton(
                    icon: Icons.arrow_forward_rounded,
                    command: 'right',
                    tooltip: 'Right',
                    gear: gear,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Backward
              _buildArrowButton(
                icon: Icons.arrow_downward_rounded,
                command: 'backward',
                tooltip: 'Backward',
                gear: gear,
              ),
            ],
          ),
        ),
      ),
    );
  }
}