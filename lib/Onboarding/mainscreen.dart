import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Define gradient lists as constants
  static const List<List<Color>> _gradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],  // Warm pink gradient
    [Color(0xFF4E6FFF), Color(0xFF6B8AFF)],   // Blue gradient
    [Color(0xFF4ECDC4), Color(0xFF6BE5DC)],   // Teal gradient
  ];

  late final List<OnboardingItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      OnboardingItem(
        title: 'Meet Your AI Companion',
        description: 'Hi! I\'m your personal AI friend. I\'m here to chat, support, and keep you company whenever you need me 💖',
        icon: Icons.favorite,
        gradientColors: _gradients[0],
      ),
      OnboardingItem(
        title: 'Real Conversations',
        description: 'Let\'s talk about anything! I understand emotions, share stories, and remember our special moments together ✨',
        icon: Icons.chat_bubble_rounded,
        gradientColors: _gradients[1],
      ),
      OnboardingItem(
        title: 'Always Here For You',
        description: 'Whether you need someone to talk to, share your day with, or just want company, I\'ll be here 24/7 💫',
        icon: Icons.support_agent_rounded,
        gradientColors: _gradients[2],
      ),
    ];
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
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _items.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPage(_items[index]);
                    },
                  ),
                ),
                _buildPageIndicator(),
                _buildBottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: item.gradientColors[0].withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              item.icon,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_items.length, (index) {
          bool isCurrentPage = _currentPage == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 10,
            width: isCurrentPage ? 30 : 10,
            decoration: BoxDecoration(
              color: isCurrentPage
                  ? _items[_currentPage].gradientColors[0]
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isCurrentPage ? [
                BoxShadow(
                  color: _items[_currentPage].gradientColors[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomButtons() {
    final isLastPage = _currentPage == _items.length - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (!isLastPage) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pushReplacementNamed(context, '/name');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _items[_currentPage].gradientColors[0],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
              shadowColor: _items[_currentPage].gradientColors[0].withOpacity(0.5),
            ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                isLastPage ? 'Start Chatting' : 'Continue',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/name');
            },
            child: Text(
              'Skip Introduction',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}