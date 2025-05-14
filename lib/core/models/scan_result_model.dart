import 'package:cloud_firestore/cloud_firestore.dart';

class ScanResult {
  String? id;
  final String productName;
  final List<String> materials;
  final String prodInfo;
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
    required this.prodInfo,
    required this.classification,
    required this.toDo,
    required this.notToDo,
    required this.proTip,
    this.notes = '',
    this.qty = 1,
    this.timestamp,
    this.imageUrl,
  });

  // parses response from Gemini model
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
      prodInfo: extractField('Product Info', responseText),
      classification: extractField('Classification', responseText),
      toDo: extractList('To Do', responseText),
      notToDo: extractList('Not To Do', responseText),
      proTip: extractField('Pro Tip', responseText),
    );
  }

  ScanResult copyWith({
    String? id,
    String? productName,
    List<String>? materials,
    String? prodInfo,
    String? classification,
    List<String>? toDo,
    List<String>? notToDo,
    String? proTip,
    String? notes,
    int? qty,
    DateTime? timestamp,
    String? imageUrl,
  }) {
    return ScanResult(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      materials: materials ?? this.materials,
      prodInfo: prodInfo ?? this.prodInfo,
      classification: classification ?? this.classification,
      toDo: toDo ?? this.toDo,
      notToDo: notToDo ?? this.notToDo,
      proTip: proTip ?? this.proTip,
      notes: notes ?? this.notes,
      qty: qty ?? this.qty,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory ScanResult.fromMap(Map<String, dynamic> map, {String? id}) {
    return ScanResult(
      id: id,
      productName: map['productName'] ?? '',
      materials: List<String>.from(map['materials'] ?? []),
      prodInfo: map['prodInfo'] ?? '',
      classification: map['classification'] ?? '',
      toDo: List<String>.from(map['toDo'] ?? []),
      notToDo: List<String>.from(map['notToDo'] ?? []),
      proTip: map['proTip'] ?? '',
      notes: map['notes'] ?? '',
      qty: map['qty'] ?? 1,
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap({bool isNew = false}) {
    String capitalize(String s) =>
        s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

    return {
      'productName': productName,
      'materials': materials,
      'prodInfo': prodInfo,
      'classification': capitalize(classification),
      'toDo': toDo,
      'notToDo': notToDo,
      'proTip': proTip,
      'notes': notes,
      'qty': qty,
      'timestamp': isNew
          ? FieldValue.serverTimestamp()
          : timestamp,
      'imageUrl': imageUrl,
    };
  }

}
