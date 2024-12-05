import 'package:flutter/material.dart';

class GenderTraitsScreen extends StatefulWidget {
  const GenderTraitsScreen({Key? key}) : super(key: key);

  @override
  _GenderTraitsScreenState createState() => _GenderTraitsScreenState();
}

class _GenderTraitsScreenState extends State<GenderTraitsScreen> {
  String _selectedGender = '';
  String _companionName = 'Companion'; // Default value

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('name')) {
        setState(() {
          _companionName = args['name'] as String;
        });
      }
    });
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
                    "Choose your Gender",
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
                  const SizedBox(height: 40),
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
                  const Spacer(),
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
          mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _selectedGender.isEmpty
          ? null
          : () {
        Navigator.pushNamed(
          context,
          '/rela',
          arguments: {
            'name': _companionName,
            'gender': _selectedGender,
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
          _selectedGender.isEmpty ? 'Please Select Gender' : 'Start Chatting',
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