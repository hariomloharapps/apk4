import 'package:flutter/material.dart';

import '../../Config/global_state.dart';

class AdultPersonalityTypeScreen extends StatefulWidget {
  const AdultPersonalityTypeScreen({super.key});

  @override
  State<AdultPersonalityTypeScreen> createState() => _AdultPersonalityTypeScreenState();
}

class _AdultPersonalityTypeScreenState extends State<AdultPersonalityTypeScreen> {
  String _selectedPersonality = '';
  String _companionName = '';
  String _selectedGender = '';
  String _relationshipType = 'Girlfriend'; // Default value

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _companionName = args['name']?.toString() ?? '';
          _selectedGender = args['gender']?.toString() ?? '';
          _relationshipType = args['relationshipType']?.toString() ?? 'Girlfriend';
        });
      }
    });
  }

  List<Map<String, dynamic>> _getAdultPersonalityTypes() {
    switch (_selectedGender) {
      case 'Female':
        return [
          {
            'type': 'Strong & Protective',
            'icon': Icons.shield_rounded,
            'color': const Color(0xFF2196F3),
            'description': 'Caring and protective nature',
            'details': 'A strong and dependable partner who prioritizes your safety and well-being.',
          },
          {
            'type': 'Confident & Charming',
            'icon': Icons.stars_rounded,
            'color': const Color(0xFF9C27B0),
            'description': 'Charismatic and self-assured',
            'details': 'A sophisticated and charming personality who knows how to make you feel special.',
          },
          {
            'type': 'Passionate & Romantic',
            'icon': Icons.favorite_rounded,
            'color': const Color(0xFFE91E63),
            'description': 'Deep emotional connection',
            'details': 'A romantic soul who expresses love through passionate gestures and deep affection.',
          },
          {
            'type': 'Playful & Adventurous',
            'icon': Icons.celebration_rounded,
            'color': const Color(0xFFFF5722),
            'description': 'Fun-loving and spontaneous',
            'details': 'An exciting partner who brings joy and adventure to the relationship.',
          },
        ];
      case 'male':
      default:
        return [
          {
            'type': 'Flirty & Playful',
            'icon': Icons.favorite_rounded,
            'color': const Color(0xFFFF4081),
            'description': 'Seductive and teasing personality',
            'details': 'A flirtatious partner who loves to tease and create exciting moments.',
          },
          {
            'type': 'Dominant & Assertive',
            'icon': Icons.auto_fix_high_rounded,
            'color': const Color(0xFF9C27B0),
            'description': 'Takes control and leads',
            'details': 'A confident and assertive personality who knows what they want.',
          },
          {
            'type': 'Submissive & Sweet',
            'icon': Icons.favorite_border_rounded,
            'color': const Color(0xFFE91E63),
            'description': 'Gentle and compliant nature',
            'details': 'A sweet and accommodating partner who enjoys following your lead.',
          },
          {
            'type': 'Wild & Adventurous',
            'icon': Icons.local_fire_department_rounded,
            'color': const Color(0xFFFF5722),
            'description': 'Spontaneous and daring',
            'details': 'An adventurous spirit who loves trying new experiences.',
          },
        ];
    }
  }

  void _showPersonalityDetails(Map<String, dynamic> type) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
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
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
            ],
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
        await GlobalState().setInitialSetupCompleted(true);
        Navigator.pushNamed(
          context,
          '/verification',
          arguments: {
            'name': _companionName,
            'gender': _selectedGender,
            'relationshipType': _relationshipType,
            'personalityType': _selectedPersonality,
            'isAdult': true,
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: Colors.red.withOpacity(0.5),
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

  @override
  Widget build(BuildContext context) {
    final personalityTypes = _getAdultPersonalityTypes();

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
                  const SizedBox(height: 20),
                  Text(
                    'Select Adult Personality',
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
                  Text(
                    'Choose ${_companionName.isEmpty ? 'your companion\'s' : '${_companionName}\'s'} intimate personality',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: personalityTypes.length,
                      itemBuilder: (context, index) {
                        final type = personalityTypes[index];
                        return _buildPersonalityCard(type);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContinueButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}