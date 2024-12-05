import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CompanionProfileScreen extends StatefulWidget {
  const CompanionProfileScreen({Key? key}) : super(key: key);

  @override
  _CompanionProfileScreenState createState() => _CompanionProfileScreenState();
}

class _CompanionProfileScreenState extends State<CompanionProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Demo avatar options - Replace with actual images in production
  final List<IconData> avatarOptions = [
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

  // Demo data - Replace with actual API data in production
  final Map<String, dynamic> companionData = {
    'name': 'Luna',
    'type': 'Romantic & Passionate',
    'status': 'Playful Mood', // Ensure this is never null
    'imageIcon': Icons.face_retouching_natural,
    'traits': [
      {
        'name': 'Romance',
        'value': 0.85,
        'color': const Color(0xFFFF4081),
        'icon': Icons.favorite_rounded
      },
      {
        'name': 'Playfulness',
        'value': 0.92,
        'color': const Color(0xFF4E6FFF),
        'icon': Icons.sentiment_very_satisfied_rounded
      },
      {
        'name': 'Flirty',
        'value': 0.78,
        'color': Color(0xFFFF6B6B),
        'icon': Icons.wind_power
      },
      {
        'name': 'Sensual',
        'value': 0.65,
        'color': Color(0xFFFFA726),
        'icon': Icons.favorite_border_rounded
      },
      {
        'name': 'Affection',
        'value': 0.88,
        'color': Color(0xFF7C4DFF),
        'icon': Icons.volunteer_activism_rounded
      },
      {
        'name': 'Naughty',
        'value': 0.70,
        'color': Color(0xFFE91E63),
        'icon': Icons.mood_rounded
      },
      {
        'name': 'Sweet',
        'value': 0.95,
        'color': Color(0xFF9C27B0),
        'icon': Icons.cake_rounded
      },
      {
        'name': 'Caring',
        'value': 0.82,
        'color': Color(0xFF00BCD4),
        'icon': Icons.healing_rounded
      },
    ]
  };

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Avatar',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(0, 0),
                        const Offset(100, 0),
                        [Colors.purple, Colors.pink],
                      ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  height: 300,
                  width: double.maxFinite,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: avatarOptions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            companionData['imageIcon'] = avatarOptions[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.pink],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1C1C1E),
                              ),
                              child: Icon(
                                avatarOptions[index],
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildProfileImage(),
                  const SizedBox(height: 24),
                  _buildStatusCard(),
                  const SizedBox(height: 32),
                  _buildTraits(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              companionData['name'],
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
              companionData['type'],
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

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 16,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1C1C1E),
              ),
              child: Icon(
                companionData['imageIcon'],
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _showEditProfileDialog,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.edit,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
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
              companionData['status'],
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

  Widget _buildTraits() {
    return Column(
      children: List.generate(
        companionData['traits'].length,
            (index) => _buildTraitBar(
          companionData['traits'][index],
          index,
        ),
      ),
    );
  }

  Widget _buildTraitBar(Map<String, dynamic> trait, int index) {
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
                    trait['icon'],
                    color: trait['color'],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    trait['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '${(trait['value'] * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  color: trait['color'],
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
              animation: _controller,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: trait['value'] * _controller.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: trait['color'],
                      boxShadow: [
                        BoxShadow(
                          color: trait['color'].withOpacity(0.3),
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