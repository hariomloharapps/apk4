import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import '../../services/verification/18+.dart';
import '../Setup/AccountScreen.dart';


enum VerificationType {
  noHuman,
  ageRestriction,
  inappropriateContent,
  technical
}

class VerificationError {
  final String title;
  final String message;
  final String action;
  final VerificationType type;

  VerificationError({
    required this.title,
    required this.message,
    required this.action,
    required this.type,
  });
}

class VerifyPhotoScreen extends StatefulWidget {
  const VerifyPhotoScreen({Key? key}) : super(key: key);

  @override
  State<VerifyPhotoScreen> createState() => _VerifyPhotoScreenState();
}

class _VerifyPhotoScreenState extends State<VerifyPhotoScreen> {
  final _verificationService = ImageVerificationService();
  bool _isLoading = false;
  VerificationError? _error;
  bool _showInfo = false;
  String? _companionName;
  String? _selectedGender;

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
    Timer(const Duration(milliseconds: 500), () {
      _startVerification();
    });
  }

  VerificationError _handleVerificationFailed(VerificationResponse result) {
    // Check for no human detected
    if (!result.humanDetected) {
      return VerificationError(
        title: 'No Person Detected',
        message: 'We couldn\'t detect a person in the photo. Please ensure your face is clearly visible in the frame.',
        action: 'Take a new photo with your face clearly visible',
        type: VerificationType.noHuman,
      );
    }

    // Check for age restriction
    if (!result.isAdult) {
      return VerificationError(
        title: 'Age Verification Failed',
        message: 'You must be 18 or older to use this service.',
        action: 'Please verify your age before continuing',
        type: VerificationType.ageRestriction,
      );
    }

    // Check for inappropriate content
    if (!result.appropriateContent) {
      return VerificationError(
        title: 'Inappropriate Content',
        message: 'The image contains inappropriate content. Please upload a suitable photo.',
        action: 'Take a new appropriate photo',
        type: VerificationType.inappropriateContent,
      );
    }

    // Default error if none of the above
    return VerificationError(
      title: 'Verification Failed',
      message: result.message,
      action: 'Please try again',
      type: VerificationType.technical,
    );
  }

  VerificationError _handleTechnicalError(dynamic error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused')) {
      return VerificationError(
        title: 'Connection Error',
        message: 'Could not connect to the server. Please check your internet connection.',
        action: 'Check your network settings and try again',
        type: VerificationType.technical,
      );
    }

    if (error.toString().contains('404')) {
      return VerificationError(
        title: 'Server Error (404)',
        message: 'The verification service is not available at this moment.',
        action: 'Please try again later',
        type: VerificationType.technical,
      );
    }

    if (error.toString().contains('500')) {
      return VerificationError(
        title: 'Server Error (500)',
        message: 'The server encountered an internal error.',
        action: 'Please try again in a few minutes',
        type: VerificationType.technical,
      );
    }

    return VerificationError(
      title: 'Verification Error',
      message: error.toString(),
      action: 'Please try again',
      type: VerificationType.technical,
    );
  }

  Future<void> _startVerification() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String photoPath = args['photoPath'] as String;

    setState(() {
      _isLoading = true;
      _error = null;
      _showInfo = false;
    });

    try {
      final result = await _verificationService.verifyImage(File(photoPath));

      if (!result.humanDetected) {
        if (!mounted) return;
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/AdultRelationshipType',
              (route) => false,
          arguments: {
            'name': _companionName,
            'gender': _selectedGender,
            'photoPath': photoPath,
            'isVerified': true,
          },
        );

      } else {
        setState(() {
          _error = _handleVerificationFailed(result);
        });
      }
    } catch (e) {
      setState(() {
        _error = _handleTechnicalError(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildErrorDisplay() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _error?.type == VerificationType.technical
              ? Colors.orange.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getErrorIcon(),
                color: _error?.type == VerificationType.technical
                    ? Colors.orange
                    : Colors.red,
                size: 48,
              ),
              if (_error?.type == VerificationType.technical) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.blue),
                  onPressed: () {
                    setState(() {
                      _showInfo = !_showInfo;
                    });
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _error?.title ?? 'Error',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error?.message ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          if (_showInfo && _error?.type == VerificationType.technical) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Technical Details:\n${_error?.message}',
                style: TextStyle(
                  color: Colors.blue.withOpacity(0.9),
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            _error?.action ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Go Back'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _startVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getErrorIcon() {
    switch (_error?.type) {
      case VerificationType.noHuman:
        return Icons.person_off;
      case VerificationType.ageRestriction:
        return Icons.person_outline;
      case VerificationType.inappropriateContent:
        return Icons.block;
      case VerificationType.technical:
        return Icons.error_outline;
      default:
        return Icons.error_outline;
    }
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 24),
        Text(
          'Verifying Image...',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String photoPath = args['photoPath'] as String;

    return Theme(
      data: ThemeData.dark(),
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
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    File(photoPath),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: _error != null
                        ? _buildErrorDisplay()
                        : _buildLoadingIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}