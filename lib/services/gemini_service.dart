import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyCY7wjLSk2SIut_taA0tX6ov0-lLA9xPiQ';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> generateResponse(String prompt) async {
    try {
      // Enhanced prompt for finance-specific responses
      final financePrompt = '''
      You are a helpful financial assistant for a mobile finance app. 
      Please provide accurate, helpful financial advice and information.
       Use markdown formatting for better readability:
      - Use **bold** for important terms
      - Use bullet points for lists
      - Use numbered lists for step-by-step instructions
      - Use headers (##) for section titles when appropriate
      Keep responses concise and user-friendly.
      
      User question: $prompt
      ''';

      final content = [Content.text(financePrompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Sorry, I couldn\'t generate a response.';
    } catch (e) {
      return 'Sorry, I encountered an error: ${e.toString()}';
    }
  }
}
