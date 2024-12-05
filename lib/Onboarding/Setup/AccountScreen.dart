import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Config/RelationshipConfig.dart';
import '../../Config/global_state.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  bool _isLoading = true;
  String _setupStatus = 'Initializing your account...';
  Map<String, dynamic> _userData = {};
  List<String> _missingFields = [];
  double _setupProgress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSetup();
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _showResponseDialog(BuildContext context, Map<String, dynamic> response, bool isError) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color(0xFF1C1C1E),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: isError ? Colors.red : Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  isError ? 'Error' : 'Success!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isError) ...[

                        _buildResponseField('User ID', response['user_id']?.toString() ?? 'N/A'),
                        // _buildResponseField('Name', response['name']?.toString() ?? 'N/A'),
                        // _buildResponseField('Relationship',
                        //     response['relationship']?['relationship_type']?.toString() ?? 'N/A'),
                      ] else ...[
                        Text(
                          response['error']?.toString() ?? 'Unknown error occurred',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        if (response['detail'] != null)
                          Text(
                            response['detail'].toString(),
                            style: TextStyle(
                              color: Colors.red.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isError)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Try Again'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () async {
                          final globalState = GlobalState();
                          await globalState.setIsSubscribed(true);
                          // await globalState.setSubscriptionEndDate(
                          //     DateTime.now().add(Duration(minutes: 10))  // Changed from days: 7 to minutes: 10
                          // );
                          await globalState.setSubscriptionEndDate(DateTime.now().add(Duration(days: 7)));


                          Navigator.of(context).pop();
                          Navigator.pushReplacementNamed(context, '/chat', arguments: response);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Continue to Chat'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponseField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,  // Takes up 2/5 of the space
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,  // Takes up 3/5 of the space
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,  // Add ellipsis for long text
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendDataToServer() async {
    try {
      // Get personality ID based on relationship type and personality type
      int? personalityId = RelationshipConfig.getPersonalityId(
          _userData['relationshipType'],
          _userData['personalityType'],
          // isAdult: _userData['isAdult'] ?? false
      );

      await GlobalState().setPersonalityId(personalityId?.toString());



      final response = await http.post(
        Uri.parse('https://apiapp2hwd.pythonanywhere.com/api/api/create-user-with-relationships/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _userData['name'],
          'gender': _userData['gender'],
          'is_verified': true,
          'is_adult': _userData['isAdult'],
          'profile_picture': null,
          'relationship': {
            'relationship_type': _userData['relationshipType'],
            'personality_type': personalityId, // Added personality ID
            'custom_name': _userData['name'],
            'ai_name': 'Buddy',
            'bio': 'Your virtual companion',
            'is_active': true
          }
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (responseData['user_id'] != null) {
          print(responseData['user_id'].toString());
          GlobalState().setUserId(responseData['user_id'].toString());
          print('User ID saved: ${GlobalState().userId}'); // Debug print
        }

        if (mounted) {

          _showResponseDialog(context, responseData, false);
        }
      } else {
        throw Exception(responseData);
      }
    } catch (e) {
      if (mounted) {
        Map<String, dynamic> errorResponse;
        if (e is Exception) {
          errorResponse = {
            'error': 'Request Failed',
            'detail': e.toString().replaceAll('Exception: ', '')
          };
        } else {
          errorResponse = {
            'error': 'Error',
            'detail': e.toString()
          };
        }
        _showResponseDialog(context, errorResponse, true);
      }
    }
  }
  Future<void> _initializeSetup() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      setState(() {
        _userData = Map<String, dynamic>.from(args);
      });
      _checkRequiredFields();
    }

    _progressTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!mounted) return;
      setState(() {
        if (_setupProgress < 0.9) {
          _setupProgress += 0.2;
          _updateSetupStatus();
        } else {
          timer.cancel();
          _finishSetup();
        }
      });
    });
  }

  void _checkRequiredFields() {
    _missingFields = [];
    final requiredFields = {
      'name': 'Companion Name',
      'gender': 'Gender',
      'relationshipType': 'Relationship Type',
      'personalityType': 'Personality Type',
      'isAdult': 'Account Type'
    };

    requiredFields.forEach((key, value) {
      if (_userData[key] == null ||
          (_userData[key] is String && _userData[key].toString().isEmpty)) {
        _missingFields.add(value);
      }
    });
  }

  void _updateSetupStatus() {
    if (_setupProgress < 0.3) {
      _setupStatus = 'Creating your personal space...';
    } else if (_setupProgress < 0.5) {
      _setupStatus = 'Configuring your preferences...';
    } else if (_setupProgress < 0.7) {
      _setupStatus = 'Setting up your companion...';
    } else if (_setupProgress < 0.9) {
      _setupStatus = 'Almost ready...';
    }
  }

  Future<void> _finishSetup() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    if (_missingFields.isEmpty) {
      await _sendDataToServer();
    }
  }

  Widget _buildProgressIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: _setupProgress,
            color: Colors.red,
            backgroundColor: Colors.red.withOpacity(0.2),
            strokeWidth: 8,
          ),
        ),
        Text(
          '${(_setupProgress * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildUserDetailCard(String title, String? value) {
    final bool isMissing = _missingFields.contains(title);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMissing ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMissing ? Colors.red.withOpacity(0.5) : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value?.toString() ?? 'Not provided',
                  style: TextStyle(
                    fontSize: 18,
                    color: isMissing ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isMissing ? Icons.error_outline : Icons.check_circle_outline,
            color: isMissing ? Colors.red : Colors.green,
            size: 24,
          ),
        ],
      ),
    );
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    _buildProgressIndicator(),
                    const SizedBox(height: 40),
                    Text(
                      _setupStatus,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                    if (_missingFields.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red.withOpacity(0.8),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Missing required information',
                                style: TextStyle(
                                  color: Colors.red.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Text(
                      'Setup Details',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildUserDetailCard('Companion Name', _userData['name']?.toString()),
                    _buildUserDetailCard('Gender', _userData['gender']?.toString()),
                    _buildUserDetailCard('Relationship Type', _userData['relationshipType']?.toString()),
                    _buildUserDetailCard('Personality Type', _userData['personalityType']?.toString()),
                    _buildUserDetailCard(
                        'Account Type',
                        _userData['isAdult'] == true ? 'Adult' : 'Standard'
                    ),
                    if (_missingFields.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Go Back & Complete Setup',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}