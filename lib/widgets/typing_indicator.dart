import 'package:flutter/material.dart';
import 'dart:math' as math;

class MinimalTypingIndicator extends StatefulWidget {
  const MinimalTypingIndicator({Key? key}) : super(key: key);

  @override
  _MinimalTypingIndicatorState createState() => _MinimalTypingIndicatorState();
}

class _MinimalTypingIndicatorState extends State<MinimalTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
              (index) => _buildDot(index * 0.15),
        ),
      ),
    );
  }

  Widget _buildDot(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = (_controller.value - delay) % 1.0;
        final opacity = math.sin(progress * math.pi);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}