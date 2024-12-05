import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Config/global_state.dart';

// Simulated API service

class VerificationService {
  static const String _apiUrl = 'https://apiapp2hwd.pythonanywhere.com/api/verify-code/';

  Future<Map<String, dynamic>> verifyCode(String code) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        body: {'code': code},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        // Handle non-200 status codes
        return {
          'success': false,
          'message': 'Error verifying code. Please try again.',
          'status': 'error'
        };
      }
    } catch (e) {
      // Handle network or parsing errors
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
        'status': 'network_error'
      };
    }
  }
}
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}
class _VerificationScreenState extends State<VerificationScreen> with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    4,
        (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(
    4,
        (index) => FocusNode(),
  );

  String _companionName = '';
  String _selectedGender = '';
  String _relationshipType = '';
  String _personalityType = '';
  bool _isAdult = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final VerificationService _verificationService = VerificationService();
  bool _isLoading = false;
  Color _accentColor = Colors.purple;
  final GlobalState _globalState = GlobalState();

  @override
  void initState() {
    super.initState();
    _loadAccentColor();
    _initializeData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  Future<void> _initializeData() async {
    await _globalState.initialize();

    // Get data from route arguments first
    if (!mounted) return;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      // If we have route arguments, save them to GlobalState
      await _saveToGlobalState(args);
      _loadFromArgs(args);
    } else {
      // If no route arguments, try to load from GlobalState
      await _loadFromGlobalState();
    }
  }

  Future<void> _saveToGlobalState(Map<String, dynamic> data) async {
    await _globalState.setCompanionName(data['name'] as String?);
    await _globalState.setSelectedGender(data['gender'] as String?);
    await _globalState.setRelationshipType(data['relationshipType'] as String?);
    await _globalState.setPersonalityType(data['personalityType'] as String?);
    await _globalState.setIsAdult(data['isAdult'] as bool? ?? false);
  }

  void _loadFromArgs(Map<String, dynamic> args) {
    setState(() {
      _companionName = args['name'] ?? '';
      _selectedGender = args['gender'] ?? '';
      _relationshipType = args['relationshipType'] ?? '';
      _personalityType = args['personalityType'] ?? '';
      _isAdult = args['isAdult'] ?? false;
    });
  }

  Future<void> _loadFromGlobalState() async {
    setState(() {
      _companionName = _globalState.companionName ?? '';
      _selectedGender = _globalState.selectedGender ?? '';
      _relationshipType = _globalState.relationshipType ?? '';
      _personalityType = _globalState.personalityType ?? '';
      _isAdult = _globalState.isAdult;
    });
  }

  Future<void> _loadAccentColor() async {
    await _globalState.initialize();

    if (await _globalState.hasColor()) {
      final colorString = _globalState.color;
      if (colorString != null) {
        setState(() {
          _accentColor = Color(int.parse(colorString.replaceAll('#', '0xFF')));
        });
      }
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 4) return;

    setState(() => _isLoading = true);

    try {
      final response = await _verificationService.verifyCode(code);

      if (response['success'] == true) {
        // Ensure data is saved to GlobalState before proceeding
        await _saveToGlobalState({
          'name': _companionName,
          'gender': _selectedGender,
          'relationshipType': _relationshipType,
          'personalityType': _personalityType,
          'isAdult': _isAdult,
        });
        _navigateToSetupScreen();
      } else {
        _showVerificationResult(false, message: response['message']);
      }
    } catch (e) {
      _showVerificationResult(false, error: e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  void _navigateToSetupScreen() {
    Navigator.pushNamed(
      context,
      '/setup-account',
      arguments: {
        'name': _companionName,
        'gender': _selectedGender,
        'relationshipType': _relationshipType,
        'personalityType': _personalityType,
        'isAdult': _isAdult,
      },
    );
  }


  void _showVerificationResult(bool isSuccess, {String? message, String? error}) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation1,
              curve: Curves.easeOutBack,
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(animation1),
            child: AlertDialog(
              backgroundColor: const Color(0xFF2C2C2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          isSuccess ? Icons.check_circle : Icons.error,
                          color: isSuccess ? Colors.green : Colors.red,
                          size: 64,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSuccess ? 'Verification Successful!' : 'Verification Failed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: TextStyle(
                        color: isSuccess ? Colors.white : Colors.red.shade300,
                        fontSize: 14,
                        fontWeight: isSuccess ? FontWeight.normal : FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSuccess ? Colors.green : Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (isSuccess) {
                        _navigateToSetupScreen();
                      } else {
                        // Clear input fields
                        for (var controller in _controllers) {
                          controller.clear();
                        }
                        _focusNodes[0].requestFocus();
                      }
                    },
                    child: Text(
                      isSuccess ? 'Continue' : 'Try Again',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black87,
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
          width: double.infinity,
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
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //

                      const SizedBox(height: 32),

                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Verification Code',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: _accentColor.withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Enter the 4-digit code sent to your device',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                                (index) => _buildCodeInput(index),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildVerifyButton(),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput(int index) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {}); // Trigger rebuild to update animation
      },
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _focusNodes[index].hasFocus
                  ? _accentColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.2),
              blurRadius: _focusNodes[index].hasFocus ? 12 : 8,
              spreadRadius: _focusNodes[index].hasFocus ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _focusNodes[index].hasFocus
                  ? _accentColor
                  : _accentColor.withOpacity(0.1),
              width: _focusNodes[index].hasFocus ? 2.5 : 2,
            ),
          ),
          child: Center(
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.0,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => _onCodeChanged(value, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            _accentColor,
            _accentColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _verifyCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
            : const Text(
          'Verify Code',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}