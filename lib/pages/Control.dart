import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ButtonControl extends StatefulWidget {
  const ButtonControl({super.key});

  @override
  State<ButtonControl> createState() => _ButtonControlState();
}

class _ButtonControlState extends State<ButtonControl> {
  String gear = 'gear1';
  int _currentGear = 1;

  // Mode: true = Hold to move (Default), false = Tap to move
  bool _isHoldMode = true;

  // Track the currently active moving command for visual feedback
  String? _activeCommand;

  Future<void> sendCommandPump(String commandPump) async {
    final url = Uri.parse('http://100.101.22.78:8000/control/$commandPump');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        debugPrint('Command sent: $commandPump');
      } else {
        debugPrint('Failed to send command: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending command: $e');
    }
  }


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

  void _setGear(int newGear) {
    if (newGear < 1 || newGear > 5) return;
    setState(() {
      _currentGear = newGear;
      gear = 'gear$newGear';
    });
  }

  void _increaseGear() {
    if (_currentGear < 5) {
      _setGear(_currentGear + 1);
    }
  }

  void _decreaseGear() {
    if (_currentGear > 1) {
      _setGear(_currentGear - 1);
    }
  }

  void _toggleHoldMode(bool value) {
    setState(() {
      _isHoldMode = value;
      _activeCommand = null;
    });
    sendCommand(gear, 'stop');
  }

  Color _getGearColor(int gearNumber) {
    switch (gearNumber) {
      case 1:
        return const Color(0xFF00B4D8); // Cyan (Gear 1)
      case 2:
        return const Color(0xFF0077B6); // Blue (Gear 2)
      case 3:
        return const Color(0xFF4361EE); // Indigo / Royal Blue (Gear 3)
      case 4:
        return const Color(0xFFF77F00); // Amber / Orange (Gear 4)
      case 5:
        return const Color(0xFFD62828); // Crimson / Red (Gear 5 - Max)
      default:
        return Colors.blueAccent;
    }
  }

  Widget _buildGearCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: Icon, Label, Active Gear Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getGearColor(_currentGear).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.speed_rounded,
                      color: _getGearColor(_currentGear),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Speed Gear',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'ระดับความเร็วเกียร์ 1 - 5',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _getGearColor(_currentGear),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getGearColor(_currentGear).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'GEAR $_currentGear',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stepper: [-] [Speed Bars] [+]
          Row(
            children: [
              IconButton.filled(
                onPressed: _currentGear > 1 ? _decreaseGear : null,
                icon: const Icon(Icons.remove_rounded, size: 24),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.blueAccent,
                  disabledBackgroundColor: Colors.grey.shade100,
                  disabledForegroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.all(12),
                ),
                tooltip: 'ลดเกียร์ (Gear Down)',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: List.generate(5, (index) {
                    final gearNum = index + 1;
                    final isActive = gearNum <= _currentGear;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 12,
                        decoration: BoxDecoration(
                          color: isActive
                              ? _getGearColor(gearNum)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: _currentGear < 5 ? _increaseGear : null,
                icon: const Icon(Icons.add_rounded, size: 24),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.blueAccent,
                  disabledBackgroundColor: Colors.grey.shade100,
                  disabledForegroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.all(12),
                ),
                tooltip: 'เพิ่มเกียร์ (Gear Up)',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Direct Gear Buttons (1 to 5)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final gearNum = index + 1;
              final isSelected = gearNum == _currentGear;
              return InkWell(
                onTap: () => _setGear(gearNum),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? _getGearColor(gearNum) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? _getGearColor(gearNum) : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: _getGearColor(gearNum).withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$gearNum',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (_isHoldMode ? Colors.blueAccent : Colors.orange)
                  .withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isHoldMode ? Icons.touch_app_rounded : Icons.radio_button_checked_rounded,
              color: _isHoldMode ? Colors.blueAccent : Colors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Hold to Move',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (_isHoldMode ? Colors.green : Colors.orange)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _isHoldMode ? 'กดค้าง' : 'แตะครั้งเดียว',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _isHoldMode ? Colors.green.shade700 : Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _isHoldMode
                      ? 'กดค้างเพื่อเคลื่อนที่ • ปล่อยมือเพื่อหยุดทันที'
                      : 'แตะเพื่อเคลื่อนที่ • แตะซ้ำหรือกด Stop เพื่อหยุด',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _isHoldMode,
            activeThumbColor: Colors.blueAccent,
            onChanged: _toggleHoldMode,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String command,
    required String tooltip,
    Color backgroundColor = Colors.blueAccent,
    Color iconColor = Colors.white,
    double size = 72,
    double iconSize = 36,
  }) {
    final isStop = command == 'stop';
    final isActive = _activeCommand == command;

    return Tooltip(
      message: tooltip,
      child: Listener(
        onPointerDown: (_) {
          if (isStop) {
            setState(() {
              _activeCommand = null;
            });
            sendCommand(gear, 'stop');
          } else if (_isHoldMode) {
            // Hold mode: start moving on press
            setState(() {
              _activeCommand = command;
            });
            sendCommand(gear, command);
          } else {
            // Tap mode: toggle on/off or change direction
            if (_activeCommand == command) {
              setState(() {
                _activeCommand = null;
              });
              sendCommand(gear, 'stop');
            } else {
              setState(() {
                _activeCommand = command;
              });
              sendCommand(gear, command);
            }
          }
        },
        onPointerUp: (_) {
          if (!isStop && _isHoldMode) {
            // Hold mode: stop moving on release
            if (_activeCommand == command) {
              setState(() {
                _activeCommand = null;
              });
              sendCommand(gear, 'stop');
            }
          }
        },
        onPointerCancel: (_) {
          if (!isStop && _isHoldMode) {
            // Safety: stop moving if gesture cancelled
            if (_activeCommand == command) {
              setState(() {
                _activeCommand = null;
              });
              sendCommand(gear, 'stop');
            }
          }
        },
        child: AnimatedScale(
          scale: isActive ? 0.90 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isStop
                  ? const Color(0xFFE63946)
                  : (isActive ? Colors.blue.shade700 : backgroundColor),
              boxShadow: [
                BoxShadow(
                  color: (isStop ? const Color(0xFFE63946) : backgroundColor)
                      .withValues(alpha: isActive ? 0.6 : 0.35),
                  blurRadius: isActive ? 12 : 8,
                  offset: isActive ? const Offset(0, 1) : const Offset(0, 4),
                ),
              ],
              border: isActive
                  ? Border.all(color: Colors.white, width: 2.5)
                  : null,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControllerPad() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Forward
          _buildControlButton(
            icon: Icons.arrow_upward_rounded,
            command: 'forward',
            tooltip: 'Forward',
          ),
          const SizedBox(height: 16),
          // Left, Stop, Right
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildControlButton(
                icon: Icons.arrow_back_rounded,
                command: 'left',
                tooltip: 'Left',
              ),
              const SizedBox(width: 16),
              _buildControlButton(
                icon: Icons.stop_rounded,
                command: 'stop',
                tooltip: 'Stop',
                backgroundColor: const Color(0xFFE63946),
                iconSize: 34,
              ),
              const SizedBox(width: 16),
              _buildControlButton(
                icon: Icons.arrow_forward_rounded,
                command: 'right',
                tooltip: 'Right',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Backward
          _buildControlButton(
            icon: Icons.arrow_downward_rounded,
            command: 'backward',
            tooltip: 'Backward',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'Robot Controller',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              _buildGearCard(),
              _buildModeSwitch(),
              const SizedBox(height: 16),
              _buildControllerPad(),
            ],
          ),
        ),
      ),
    );
  }
}