
// lib/services/api_service.dart
class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});
}

class ApiService {
  static Future<ApiResponse> sendMessage(
      String message,
      List<Map<String, dynamic>> history,
      ) async {
    // Implement your API call here
    // This is a mock implementation
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return ApiResponse(
      success: true,
      message: "This is a mock response to: $message",
    );
  }
}
