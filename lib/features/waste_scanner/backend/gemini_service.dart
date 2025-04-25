import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Initialize the Gemini model with the API key and safety settings.
  final geminiModel = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
    safetySettings: [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
    ],
  );

  Future<String> classifyWaste(Uint8List imageBytes) async {
    try {
      final imagePart = DataPart('image/jpeg', imageBytes);
      final response = await geminiModel.generateContent([
        Content.multi([
          imagePart,
          TextPart(
            'You are a waste classification expert. Analyze the object in this image and determine whether it is biodegradable or non-biodegradable. Provide a brief explanation for your classification.',
          ),
        ]),
      ]);

      return response.text ?? 'No response from Gemini';
    } catch (e) {
      return 'Error from Gemini: $e';
    }
  }
}
