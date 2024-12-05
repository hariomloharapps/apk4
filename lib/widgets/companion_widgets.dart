import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/companion_model.dart';

class CompanionHeader extends StatelessWidget {
  final String name;
  final String type;

  const CompanionHeader({
    Key? key,
    required this.name,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = ui.Gradient.linear(
                    const Offset(0, 0),
                    const Offset(100, 0),
                    [Colors.purple, Colors.pink],
                  ),
              ),
            ),
            Text(
              type,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CompanionStatusCard extends StatelessWidget {
  final String status;

  const CompanionStatusCard({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.purple.withOpacity(0.1),
        border: Border.all(
          color: Colors.purple.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current Mood',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.withOpacity(0.5), Colors.pink.withOpacity(0.5)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TraitBar extends StatelessWidget {
  final CompanionTrait trait;
  final Animation<double> animation;

  const TraitBar({
    Key? key,
    required this.trait,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    trait.icon,
                    color: Color(trait.color),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    trait.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '${(trait.value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(trait.color),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[800],
            ),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: trait.value * animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(trait.color),
                      boxShadow: [
                        BoxShadow(
                          color: Color(trait.color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}