import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BuildXApiService {
  static final BuildXApiService _instance = BuildXApiService._internal();
  factory BuildXApiService() => _instance;
  BuildXApiService._internal();

  String get apiUrl => dotenv.env['API_URL'] ?? '';
  String get modelName => dotenv.env['MODEL_NAME'] ?? 'Build X';
  int get apiTimeout => int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;
  int get maxTokens => int.tryParse(dotenv.env['MAX_TOKENS'] ?? '4096') ?? 4096;

  Future<String> sendMessage(String message, {List<Map<String, dynamic>>? history}) async {
    if (apiUrl.isEmpty) {
      throw Exception('API URL not configured. Please check your .env file.');
    }

    try {
      final messages = <Map<String, dynamic>>[];
      
      // Add history if provided
      if (history != null) {
        messages.addAll(history);
      }
      
      // Add current message
      messages.add({
        'role': 'user',
        'content': message,
      });

      final response = await http.post(
        Uri.parse('$apiUrl/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': modelName,
          'messages': messages,
          'max_tokens': maxTokens,
          'temperature': 0.7,
          'stream': false,
        }),
      ).timeout(Duration(milliseconds: apiTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response';
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<Stream<String>> sendMessageStream(String message, {List<Map<String, dynamic>>? history}) async {
    if (apiUrl.isEmpty) {
      throw Exception('API URL not configured. Please check your .env file.');
    }

    try {
      final messages = <Map<String, dynamic>>[];
      
      // Add history if provided
      if (history != null) {
        messages.addAll(history);
      }
      
      // Add current message
      messages.add({
        'role': 'user',
        'content': message,
      });

      final request = http.Request('POST', Uri.parse('$apiUrl/v1/chat/completions'));
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'model': modelName,
        'messages': messages,
        'max_tokens': maxTokens,
        'temperature': 0.7,
        'stream': true,
      });

      final streamedResponse = await http.Client().send(request);
      
      if (streamedResponse.statusCode == 200) {
        return streamedResponse.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .where((line) => line.startsWith('data: ') && !line.contains('[DONE]'))
            .map((line) {
              try {
                final data = jsonDecode(line.substring(6));
                return data['choices'][0]['delta']['content'] ?? '';
              } catch (e) {
                return '';
              }
            })
            .where((content) => content.isNotEmpty);
      } else {
        throw Exception('API Error: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  bool isConfigured() {
    return apiUrl.isNotEmpty;
  }
}