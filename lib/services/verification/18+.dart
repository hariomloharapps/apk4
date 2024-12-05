import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificationResponse {
  final bool verificationStatus;
  final bool humanDetected;
  final bool isAdult;
  final bool appropriateContent;
  final String message;

  VerificationResponse({
    required this.verificationStatus,
    required this.humanDetected,
    required this.isAdult,
    required this.appropriateContent,
    required this.message,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      verificationStatus: json['verification_status'] ?? false,
      humanDetected: json['details']['human_detected'] ?? false,
      isAdult: json['details']['is_adult'] ?? false,
      appropriateContent: json['details']['appropriate_content'] ?? false,
      message: json['message'] ?? 'Verification completed',
    );
  }
}

class ImageVerificationService {
  static const String baseUrl = 'https://apiapp2hwd.pythonanywhere.com/api/verify-image/';

  Future<VerificationResponse> verifyImage(File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl');

      var request = http.MultipartRequest('POST', uri);
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'profile_picture',
        stream,
        length,
        filename: 'image.jpg',
      );

      request.files.add(multipartFile);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        try {
          return VerificationResponse.fromJson(json.decode(response.body));
        } catch (parseError) {
          throw Exception('Failed to parse verification response: $parseError');
        }
      } else {
        throw Exception('Failed to verify image. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during image verification: $e');
    }
  }
}