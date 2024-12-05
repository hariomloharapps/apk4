import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/global_state.dart';

class PersonalityTypeScreen extends StatefulWidget {
  const PersonalityTypeScreen({Key? key}) : super(key: key);

  @override
  _PersonalityTypeScreenState createState() => _PersonalityTypeScreenState();
}

class _PersonalityTypeScreenState extends State<PersonalityTypeScreen> {
  String _selectedPersonality = '';
  String _companionName = '';
  String _selectedGender = '';
  String _relationshipType = '';
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _companionName = args['name'] as String;
          _selectedGender = args['gender'] as String;
          _relationshipType = args['relationshipType'] as String;
        });
      }
    });
  }
  Future<void> _saveColorToPreferences(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert color to hex string for storage
    String colorHex = '#${color.value.toRadixString(16).padLeft(8, '0')}';
    await prefs.setString('personality_color', colorHex);
    print('Saved color: $colorHex');
  }

  List<Map<String, dynamic>> _getPersonalityTypes() {
    if (_relationshipType == 'Best Friend' || _relationshipType == 'Bestie') {
      return [
        {
          'type': 'Supportive & Loyal',
          'icon': Icons.favorite_rounded,
          'color': Color(0xFF4E6FFF),
          'description': 'Always there through thick and thin',
          'details': 'A reliable friend who offers emotional support, keeps your secrets, and stands by your side no matter what. They\'re excellent listeners and give thoughtful advice.',
        },
        {
          'type': 'Adventurous & Fun',
          'icon': Icons.explore_rounded,
          'color': Color(0xFFFF6B6B),
          'description': 'Loves trying new things and having adventures',
          'details': 'Spontaneous and exciting, they\'re always up for new experiences. They make life more interesting and push you out of your comfort zone in the best way possible.',
        },
        {
          'type': 'Wise & Mature',
          'icon': Icons.psychology_rounded,
          'color': Colors.purple,
          'description': 'Thoughtful mentor and advisor',
          'details': 'Offers wisdom beyond their years, helps you see different perspectives, and gives valuable life advice while maintaining a fun friendship.',
        },
        {
          'type': 'Goofy & Humorous',
          'icon': Icons.sentiment_very_satisfied_rounded,
          'color': Colors.amber,
          'description': 'Always knows how to make you laugh',
          'details': 'Masters of comedy who brighten your day with their humor. They know when to be serious but excel at turning any situation into something fun.',
        },
      ];
    } else if (_relationshipType == 'Girlfriend') {
      return [
        {
          'type': 'Sweet & Caring',
          'icon': Icons.favorite_rounded,
          'color': Color(0xFFFF6B6B),
          'description': 'Gentle, nurturing, and always there for you',
          'details': 'A warm and affectionate partner who shows love through small gestures and emotional support. They\'re attentive to your needs and create a nurturing environment.',
        },
        {
          'type': 'Playful & Cheerful',
          'icon': Icons.mood_rounded,
          'color': Color(0xFF4E6FFF),
          'description': 'Brings joy and excitement to your life',
          'details': 'Energetic and fun-loving, they make every moment special with their positive attitude and playful nature. They love surprises and spontaneous adventures.',
        },
        {
          'type': 'Shy & Introverted',
          'icon': Icons.face_retouching_natural_rounded,
          'color': Colors.amber,
          'description': 'Sweet, thoughtful, and deeply caring',
          'details': 'Quiet but deeply affectionate, they show love through meaningful gestures and deep conversations. They prefer intimate moments over grand displays of affection.',
        },
        {
          'type': 'Romantic & Passionate',
          'icon': Icons.local_fire_department_rounded,
          'color': Color(0xFFFF4081),
          'description': 'Deeply affectionate and emotionally expressive',
          'details': 'Intensely romantic and passionate about the relationship. They love expressing their feelings through grand gestures and creating magical moments.',
        },
        {
          'type': 'Adult',
          'icon': Icons.lock_rounded,
          'color': Colors.red,
          'description': 'Mature content and themes',
          'isAdult': true,
          'details': 'Contains mature themes and content. Age verification required.',
        },
      ];
    } else if (_relationshipType == 'Boyfriend') {
      return [
        {
          'type': 'Protective & Caring',
          'icon': Icons.security_rounded,
          'color': Color(0xFF4E6FFF),
          'description': 'Strong, reliable, and nurturing',
          'details': 'A dependable partner who makes you feel safe and protected. They\'re attentive to your needs while maintaining a gentle and caring nature.',
        },

        {
          'type': 'Shy & Sensitive',
          'icon': Icons.face_retouching_natural_rounded,
          'color': Colors.amber,
          'description': 'Thoughtful, gentle, and understanding',
          'details': 'A sensitive soul who connects on a deep emotional level. They\'re great listeners and show their love through subtle but meaningful actions.',
        },
        {
          'type': 'Romantic & Devoted',
          'icon': Icons.favorite_border_rounded,
          'color': Color(0xFFFF4081),
          'description': 'Affectionate and deeply committed',
          'details': 'A romantic at heart who loves expressing their feelings. They put effort into making you feel special and creating romantic moments.',
        },
        {
          'type': 'Adult',
          'icon': Icons.lock_rounded,
          'color': Colors.red,
          'description': 'Mature content and themes',
          'isAdult': true,
          'details': 'Contains mature themes and content. Age verification required.',
        },
      ];
    }
    return [];
  }

  void _showPersonalityDetails(Map<String, dynamic> type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFF1C1C1E),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                type['icon'] as IconData,
                size: 48,
                color: type['color'] as Color,
              ),
              const SizedBox(height: 16),
              Text(
                type['type'] as String,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: type['color'] as Color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                type['details'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Choose Personality',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.purple.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select $_companionName\'s personality type',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getPersonalityTypes().length,
                      itemBuilder: (context, index) {
                        final type = _getPersonalityTypes()[index];
                        return _buildPersonalityCard(type);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContinueButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalityCard(Map<String, dynamic> type) {
    final isSelected = _selectedPersonality == type['type'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPersonality = type['type'] as String;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? (type['color'] as Color).withOpacity(0.2) : const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? (type['color'] as Color) : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: (type['color'] as Color).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (type['color'] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  type['icon'] as IconData,
                  size: 32,
                  color: isSelected ? (type['color'] as Color) : Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type['type'] as String,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? (type['color'] as Color) : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: (type['color'] as Color).withOpacity(0.7),
                ),
                onPressed: () => _showPersonalityDetails(type),
              ),
              if (type['isAdult'] == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '18+',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _selectedPersonality.isEmpty
          ? null
          : () async {
        // Get the selected personality type's color
        final selectedType = _getPersonalityTypes().firstWhere(
              (type) => type['type'] == _selectedPersonality,
          orElse: () => {'color': Colors.purple},
        );

        // Save the color to SharedPreferences
        await _saveColorToPreferences(selectedType['color'] as Color);

        if (_selectedPersonality == 'Adult') {
          Navigator.pushNamed(
            context,
            '/adult-verification',
            arguments: {
              'name': _companionName,
              'gender': _selectedGender,
              'relationshipType': _relationshipType,
            },
          );
        } else {
          await GlobalState().setInitialSetupCompleted(true);
          Navigator.pushNamed(
            context,
            '/verification',
            arguments: {
              'name': _companionName,
              'gender': _selectedGender,
              'relationshipType': _relationshipType,
              'personalityType': _selectedPersonality,
              'isAdult': false,
            },
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: Colors.purple.withOpacity(0.5),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          _selectedPersonality.isEmpty ? 'Please Select Personality' : 'Continue',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}