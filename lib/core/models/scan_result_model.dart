import 'package:cloud_firestore/cloud_firestore.dart';

class ScanResult {
  final String? id;
  final String productName;
  final List<String> materials;
  final String classification;
  final List<String> toDo;
  final List<String> notToDo;
  final String proTip;
  final String notes;
  final int qty;
  final DateTime? timestamp;
  final String? imageUrl;

  ScanResult({
    this.id,
    required this.productName,
    required this.materials,
    required this.classification,
    required this.toDo,
    required this.notToDo,
    required this.proTip,
    this.notes = '',
    this.qty = 1,
    this.timestamp,
    this.imageUrl,
  });

  // from Gemini response
  factory ScanResult.fromResponse(String responseText) {
    String extractField(String label, String text) {
      final regex = RegExp('$label\\s*:\\s*(.*)', caseSensitive: false);
      return regex.firstMatch(text)?.group(1)?.trim() ?? 'Unknown';
    }

    List<String> extractList(String label, String text) {
      final pattern = RegExp('$label\\s*:\\s*((?:\\n-\\s+.*)+)', caseSensitive: false);
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)!
            .split('\n')
            .map((line) => line.replaceFirst('- ', '').trim())
            .where((line) => line.isNotEmpty)
            .toList();
      }
      return [];
    }

    return ScanResult(
      productName: extractField('Product Name', responseText),
      materials: extractList('Material', responseText),
      classification: extractField('Classification', responseText),
      toDo: extractList('To Do', responseText),
      notToDo: extractList('Not To Do', responseText),
      proTip: extractField('Pro Tip', responseText),
    );
  }

  // from Firestore
  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      id: map['id'] ?? '',
      productName: map['productName'] ?? '',
      materials: List<String>.from(map['materials'] ?? []),
      classification: map['classification'] ?? '',
      toDo: List<String>.from(map['toDo'] ?? []),
      notToDo: List<String>.from(map['notToDo'] ?? []),
      proTip: map['proTip'] ?? '',
      notes: map['notes'] ?? '',
      qty: map['qty'] ?? 0,
      timestamp: map['timestamp'] ?? Timestamp.now(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // to Firestore
  Map<String, dynamic> toMap() {
    String capitalize(String s) =>
        s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

    return {
      'productName': productName,
      'materials': materials,
      'classification': capitalize(classification),
      'toDo': toDo,
      'notToDo': notToDo,
      'proTip': proTip,
      'notes': notes,
      'qty': qty,
      'timestamp': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
    };
  }
}
