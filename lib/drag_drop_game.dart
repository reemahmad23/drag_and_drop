import 'package:flutter/material.dart';

class DragDropGame extends StatefulWidget {
  const DragDropGame({super.key});

  @override
  State<DragDropGame> createState() => _DragDropGameState();
}

class _DragDropGameState extends State<DragDropGame> {
  final List<Color> balls = [Colors.red, Colors.green, Colors.blue];

  final Map<Color, bool> matched = {
    Colors.red: false,
    Colors.green: false,
    Colors.blue: false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drag & Drop Game"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: balls.map((color) {
              return Draggable<Color>(
                data: color,
                feedback: ballWidget(color, 50, withShadow: true), // يظهر أثناء السحب
                childWhenDragging: ballWidget(Colors.grey.shade300, 50), // مكانها يبهت
                child: matched[color]! ? const SizedBox(width: 50, height: 50) : ballWidget(color, 50),
              );
            }).toList(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: balls.map((color) {
              return DragTarget<Color>(
                onWillAcceptWithDetails: (data) => true,
                onAcceptWithDetails: (data) {
                  if (data == color) {
                    // صح ✅
                    setState(() {
                      matched[color] = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Correct! ${colorName(color)} matched")),
                    );
                  } else {
                    // غلط ❌
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Wrong match! Try again")),
                    );
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.3),
                      border: Border.all(color: color, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        colorName(color),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ويدجت للكورة
  Widget ballWidget(Color color, double size, {bool withShadow = false}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: withShadow
            ? [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                )
              ]
            : null,
      ),
    );
  }

  String colorName(Color color) {
    if (color == Colors.red) return "Red";
    if (color == Colors.green) return "Green";
    if (color == Colors.blue) return "Blue";
    return "Color";
  }
}