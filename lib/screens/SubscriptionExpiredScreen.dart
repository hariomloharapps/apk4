import 'package:flutter/material.dart';
import 'dart:math' as math;

// import 'package:rive_animated_icon/rive_animated_icon.dart';

class SubscriptionExpiredScreen extends StatefulWidget {
  const SubscriptionExpiredScreen({super.key});

  @override
  State<SubscriptionExpiredScreen> createState() => _SubscriptionExpiredScreenState();
}

class _SubscriptionExpiredScreenState extends State<SubscriptionExpiredScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2C2C2E),
          secondary: Color(0xFF48484A),
          surface: Color(0xFF1C1C1E),
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF121212),
                const Color(0xFF1C1C1E).withOpacity(0.95),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Clock Icon
                    Icon(Icons.lock_clock , size: 100,),
                    const SizedBox(height: 30),

                    // Title with shadow effect
                    Text(
                      'Subscription Expired',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.red.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description text
                    Text(
                      'Your 7-day subscription period has ended',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Additional info
                    Text(
                      'Please contact support if you need any assistance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}