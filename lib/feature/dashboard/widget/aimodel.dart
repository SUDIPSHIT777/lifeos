// import 'package:flutter/material.dart';
// import 'package:flutter_3d_controller/flutter_3d_controller.dart';

// class AIModel extends StatefulWidget {
//   const AIModel({super.key});

//   @override
//   State<AIModel> createState() => _AIModelState();
// }

// class _AIModelState extends State<AIModel> {
//   final Flutter3DController _controller = Flutter3DController();
//   bool _started = false;
//   Future<void> _onLoad(dynamic _) async {
//     final animations = await _controller.getAvailableAnimations();

//     if (animations.isNotEmpty && !_started) {
//       _controller.playAnimation(animationName: animations.first, loopCount: 0);
//       _started = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 200,
//       height: 200,
//       child: Flutter3DViewer(
//         controller: _controller,
//         src: 'assets/robot_playground.glb',
//         onLoad: _onLoad,
//       ),
//     );
//   }
// }
