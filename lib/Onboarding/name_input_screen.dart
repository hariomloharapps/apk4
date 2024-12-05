import 'package:flutter/material.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({Key? key}) : super(key: key);

  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _companionName = '';

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

                  const SizedBox(height: 20),
                  // Title
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
                  const SizedBox(height: 40),
                  // Name Input Section
                  _buildNameSection(),
                  // Spacer to push button to bottom
                  const Spacer(),
                  // Continue Button
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

  Widget _buildNameSection() {
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
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Enter a name...',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                Icons.favorite,
                color: Colors.pink.withOpacity(0.7),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _companionName = value.trim();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _companionName.isEmpty
          ? null
          : () {
        Navigator.pushNamed(
          context,
          '/gender',
          arguments: {'name': _companionName},
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
          _companionName.isEmpty ? 'Please Enter Name' : 'Continue',
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