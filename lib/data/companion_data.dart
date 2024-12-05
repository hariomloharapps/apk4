import 'package:flutter/material.dart';
import '../models/companion_model.dart';

class CompanionDataProvider {
  static final List<IconData> avatarOptions = [
    Icons.face_retouching_natural,
    Icons.face_outlined,
    Icons.face_unlock_rounded,
    Icons.face_retouching_natural_outlined,
    Icons.face_2,
    Icons.face_3,
    Icons.face_4,
    Icons.face_5,
    Icons.face_6,
  ];

  static CompanionData getMockCompanionData() {
    return CompanionData(
      name: 'Luna',
      type: 'Romantic & Passionate',
      status: 'Playful Mood',
      imageIcon: Icons.face_retouching_natural,
      traits: [
        CompanionTrait(
          name: 'Romance',
          value: 0.85,
          color: 0xFFFF4081,
          icon: Icons.favorite_rounded,
        ),
        CompanionTrait(
          name: 'Playfulness',
          value: 0.92,
          color: 0xFF4E6FFF,
          icon: Icons.sentiment_very_satisfied_rounded,
        ),
        CompanionTrait(
          name: 'Flirty',
          value: 0.78,
          color: 0xFFFF6B6B,
          icon: Icons.wind_power,
        ),
        CompanionTrait(
          name: 'Sensual',
          value: 0.65,
          color: 0xFFFFA726,
          icon: Icons.favorite_border_rounded,
        ),
        CompanionTrait(
          name: 'Affection',
          value: 0.88,
          color: 0xFF7C4DFF,
          icon: Icons.volunteer_activism_rounded,
        ),
        CompanionTrait(
          name: 'Naughty',
          value: 0.70,
          color: 0xFFE91E63,
          icon: Icons.mood_rounded,
        ),
        CompanionTrait(
          name: 'Sweet',
          value: 0.95,
          color: 0xFF9C27B0,
          icon: Icons.cake_rounded,
        ),
        CompanionTrait(
          name: 'Caring',
          value: 0.82,
          color: 0xFF00BCD4,
          icon: Icons.healing_rounded,
        ),
      ],
    );
  }
}