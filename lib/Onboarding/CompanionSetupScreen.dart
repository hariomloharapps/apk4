import 'package:flutter/material.dart';

class CompanionSetupScreen extends StatefulWidget {
  const CompanionSetupScreen({Key? key}) : super(key: key);

  @override
  _CompanionSetupScreenState createState() => _CompanionSetupScreenState();
}

class _CompanionSetupScreenState extends State<CompanionSetupScreen> {
  String _selectedGender = '';
  String _companionName = '';
  final TextEditingController _nameController = TextEditingController();

  // Personality traits that users can select
  final Map<String, bool> _traits = {
    'Caring' : false,
    'Playful': false,
    'Smart' : false,
    'Creative': false,
    'Funny' : false,
    'Sweet' : false,
  };

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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Create Your AI Companion',
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
                    const SizedBox(height: 30),
                    _buildGenderSelection(),
                    const SizedBox(height: 30),
                    _buildNameInput(),
                    const SizedBox(height: 30),
                    _buildPersonalityTraits(),
                    const SizedBox(height: 40),
                    _buildContinueButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Gender',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildGenderCard(
                'Female',
                Icons.face_3_rounded,
                const Color(0xFFFF6B6B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderCard(
                'Male',
                Icons.face_6_rounded,
                const Color(0xFF4E6FFF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(String gender, IconData icon, Color color) {
    final isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
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
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? color : Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            Text(
              gender,
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

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name Your Companion',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter a name...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            fillColor: const Color(0xFF2C2C2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              Icons.favorite,
              color: Colors.pink.withOpacity(0.7),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _companionName = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPersonalityTraits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Personality Traits',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _traits.entries.map((trait) {
            return FilterChip(
              selected: trait.value,
              label: Text(trait.key),
              onSelected: (selected) {
                setState(() {
                  _traits[trait.key] = selected;
                });
              },
              selectedColor: Colors.purple.withOpacity(0.3),
              checkmarkColor: Colors.white,
              backgroundColor: const Color(0xFF2C2C2E),
              labelStyle: TextStyle(
                color: trait.value ? Colors.white : Colors.white.withOpacity(0.7),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: trait.value ? Colors.purple : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    bool canContinue = _selectedGender.isNotEmpty &&
        _companionName.isNotEmpty &&
        _traits.values.any((selected) => selected);

    return ElevatedButton(
      onPressed: canContinue
          ? () {
        // Here you would typically save the companion settings
        // and navigate to the chat screen
        final selectedTraits = _traits.entries
            .where((trait) => trait.value)
            .map((trait) => trait.key)
            .toList();

        Navigator.pushReplacementNamed(
          context,
          '/chat',
          arguments: {
            'gender': _selectedGender,
            'name': _companionName,
            'traits': selectedTraits,
          },
        );
      }
          : null,
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
          canContinue ? 'Start Chatting' : 'Please Complete Setup',
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
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}