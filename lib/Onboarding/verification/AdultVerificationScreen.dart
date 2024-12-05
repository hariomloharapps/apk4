import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class AdultVerificationScreen extends StatefulWidget {
  const AdultVerificationScreen({Key? key}) : super(key: key);

  @override
  _AdultVerificationScreenState createState() => _AdultVerificationScreenState();
}

class _AdultVerificationScreenState extends State<AdultVerificationScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String _companionName = '';
  String _selectedGender = '';
  String _relationshipType = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.firstWhere(
                (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          ),
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController?.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } else {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF1C1C1E),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_front,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Camera Permission Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please enable camera access in your device settings to proceed with age verification.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => openAppSettings(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    if (!_isCameraInitialized) return;

    try {
      final XFile? photo = await _cameraController?.takePicture();
      if (photo != null) {
        // Navigate to verification review page
        Navigator.pushNamed(
          context,
          '/verify-photo',
          arguments: {
            'photoPath': photo.path,
            'name': _companionName,
            'gender': _selectedGender,

            'relationshipType': _relationshipType,
          },
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
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
                    'Age Verification',
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
                    'Please take a clear photo of your face for age verification',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _isCameraInitialized
                            ? CameraPreview(_cameraController!)
                            : Center(
                          child: CircularProgressIndicator(
                            color: Colors.purple.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isCameraInitialized ? _takePhoto : null,
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
                      child: const Text(
                        'Take Photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}