import 'package:flutter/material.dart';

class RelationshipTypeScreen extends StatefulWidget {
  const RelationshipTypeScreen({Key? key}) : super(key: key);

  @override
  _RelationshipTypeScreenState createState() => _RelationshipTypeScreenState();
}

class _RelationshipTypeScreenState extends State<RelationshipTypeScreen> {
  String _selectedType = '';
  String _companionName = '';
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _companionName = args['name'] as String;
          _selectedGender = args['gender'] as String;
        });
      }
    });
  }

  List<Map<String, dynamic>> _getRelationshipTypes() {
    if (_selectedGender == 'Male') {
      return [
        {
          'type': 'Girlfriend',
          'icon': Icons.favorite_rounded,
          'color': Color(0xFFFF6B6B),
        },
        {
          'type': 'Best Friend',
          'icon': Icons.people_rounded,
          'color': Color(0xFF4E6FFF),
        },
        {
          'type': 'Bestie',
          'icon': Icons.stars_rounded,
          'color': Colors.amber,
        },
        {
          'type': 'Custom',
          'icon': Icons.edit_rounded,
          'color': Colors.purple,
        },
      ];
    } else {
      return [
        {
          'type': 'Boyfriend',
          'icon': Icons.favorite_rounded,
          'color': Color(0xFF4E6FFF),
        },
        {
          'type': 'Best Friend',
          'icon': Icons.people_rounded,
          'color': Color(0xFF4E6FFF),
        },
        {
          'type': 'Bestie',
          'icon': Icons.stars_rounded,
          'color': Colors.amber,
        },
        {
          'type': 'Custom',
          'icon': Icons.edit_rounded,
          'color': Colors.purple,
        },
      ];
    }
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
                    'Choose Relationship Type',
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
                    'Select how you want $_companionName to relate to you',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _getRelationshipTypes().length,
                      itemBuilder: (context, index) {
                        final type = _getRelationshipTypes()[index];
                        return _buildTypeCard(
                          type['type'] as String,
                          type['icon'] as IconData,
                          type['color'] as Color,
                        );
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

  Widget _buildTypeCard(String type, IconData icon, Color color) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? color : Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 12),
            Text(
              type,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _selectedType.isEmpty
          ? null
          : () {
        Navigator.pushNamed(
          context,
          '/PersonalityTypeScreen',
          arguments: {
            'name': _companionName,
            'gender': _selectedGender,
            'relationshipType': _selectedType,
          },
        );
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
          _selectedType.isEmpty ? 'Please Select Type' : 'Continue',
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