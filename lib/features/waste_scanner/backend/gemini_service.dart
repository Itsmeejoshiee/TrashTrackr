import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';

class GeminiService {
  final geminiModel = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
    safetySettings: [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
    ],
  );

  Future<ScanResult> classifyWaste(Uint8List imageBytes) async {
    try {
      final imagePart = DataPart('image/jpeg', imageBytes);
      final response = await geminiModel.generateContent([
        Content.multi([
          imagePart,
          TextPart(
            '''
            You are a waste classification expert. Analyze the object in this image and return the following in clearly labeled format:
            
            Product Name: [e.g. Aluminum Soda Can]
             
            Material: [e.g. Plastic, Metal] Do not include other description.
            - 
            - 
            - [increase number of bullets if necessary]
              
            Classification: [Biodegradable / Non-Biodegradable / Recyclable]  
            
            To Do: short to-do only, in 10 words
            -  
            -   
            
            Not To Do: short not to-do only, in 10 wordsS
            -   
            -   
            
            Pro Tip: [Short advice about proper disposal or recycling benefits.]
            ''',
          ),

        ]),
      ]);

      final text = response.text ?? 'No response from Gemini';
      return ScanResult.fromResponse(text);
    } catch (e) {
      return ScanResult(
        productName: 'Error',
        materials: [],
        classification: 'non-biodegradable',
        toDo: [],
        notToDo: [],
        proTip: '',
      );
    }
  }
}
