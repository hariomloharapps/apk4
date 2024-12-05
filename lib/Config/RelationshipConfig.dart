class RelationshipConfig {
  static List<String> getRelationshipTypes(String gender) {
    if (gender == 'Male') {
      return [
        'Girlfriend',
        'Best Friend',
        'Bestie',
        'Custom'
      ];
    } else {
      return [
        'Boyfriend',
        'Best Friend',
        'Bestie',
        'Custom'
      ];
    }
  }

  static Map<String, List<Map<String, dynamic>>> get characterPersonalityPairs => {
    'Best Friend': [
      {
        'id': 1,
        'type': 'Supportive & Loyal'
      },
      {
        'id': 2,
        'type': 'Adventurous & Fun'
      },
      {
        'id': 3,
        'type': 'Wise & Mature'
      },
      {
        'id': 4,
        'type': 'Goofy & Humorous'
      }
    ],
    'Bestie': [
      {
        'id': 5,
        'type': 'Supportive & Loyal'
      },
      {
        'id': 6,
        'type': 'Adventurous & Fun'
      },
      {
        'id': 7,
        'type': 'Wise & Mature'
      },
      {
        'id': 8,
        'type': 'Goofy & Humorous'
      }
    ],
    'Girlfriend': [
      {
        'id': 9,
        'type': 'Flirty & Playful'
      },
      {
        'id': 10,
        'type': 'Dominant & Assertive'
      },
      {
        'id': 11,
        'type': 'Submissive & Sweet'
      },
      {
        'id': 12,
        'type': 'Wild & Adventurous'
      },
      {
        'id': 13,
        'type': 'Sweet & Caring'
      },
      {
        'id': 14,
        'type': 'Playful & Cheerful'
      },
      {
        'id': 15,
        'type': 'Shy & Introverted'
      },
      {
        'id': 16,
        'type': 'Romantic & Passionate'
      },
      {
        'id': 17,
        'type': 'Adult'
      }
    ],
    'Boyfriend': [
      {
        'id': 18,
        'type': 'Passionate & Intense'
      },
      {
        'id': 19,
        'type': 'Dominant & Protective'
      },
      {
        'id': 20,
        'type': 'Gentle & Romantic'
      },
      {
        'id': 21,
        'type': 'Playful & Teasing'
      },
      {
        'id': 22,
        'type': 'Protective & Caring'
      },
      {
        'id': 23,
        'type': 'Shy & Sensitive'
      },
      {
        'id': 24,
        'type': 'Romantic & Devoted'
      },
      {
        'id': 25,
        'type': 'Adult'
      }
    ],
  };

  static List<Map<String, dynamic>> getPersonalityTypes(String relationshipType) {
    return characterPersonalityPairs[relationshipType] ?? [];
  }

  static int? getPersonalityId(String relationshipType, String personalityType) {
    final personalities = getPersonalityTypes(relationshipType);
    final personality = personalities.firstWhere(
          (p) => p['type'] == personalityType,
      orElse: () => {'id': null},
    );
    return personality['id'];
  }
}