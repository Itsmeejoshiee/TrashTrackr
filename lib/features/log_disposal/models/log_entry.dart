import '../../../core/models/scan_result_model.dart';

/// A model class representing a single log entry (e.g., trash pickup or disposal record).
final class LogEntry {
  String imageUrl;
  String title;
  String wasteType;
  DateTime timestamp;
  String productInfo;
  List<String> productProperties;
  List<String> disposalGuideToDo;
  List<String> disposalGuideNotToDo;
  String disposalGuideProTip;
  String disposalLocation;
  String? notes;
  String? quantity;

  LogEntry({
    required this.imageUrl,
    required this.title,
    required this.wasteType,
    required this.timestamp,
    required this.productInfo,
    required this.productProperties,
    required this.disposalGuideToDo,
    required this.disposalGuideNotToDo,
    required this.disposalGuideProTip,
    required this.disposalLocation,
    this.notes,
    this.quantity,
  });

  LogEntry copyWith({
    String? title,
    List<String>? productProperties,
    String? productInfo,
    String? notes,
    String? quantity,
    String? disposalGuideProTip,
    List<String>? disposalGuideToDo,
    List<String>? disposalGuideNotToDo,
    String? wasteType,
  }) {
    return LogEntry(
      imageUrl: imageUrl,
      title: title ?? this.title,
      wasteType: wasteType ?? this.wasteType,
      timestamp: timestamp,
      productInfo: productInfo ?? this.productInfo,
      productProperties: productProperties ?? this.productProperties,
      disposalGuideToDo: disposalGuideToDo ?? this.disposalGuideToDo,
      disposalGuideNotToDo: disposalGuideNotToDo ?? this.disposalGuideNotToDo,
      disposalGuideProTip: disposalGuideProTip ?? this.disposalGuideProTip,
      disposalLocation: disposalLocation,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Converts a ScanResult to a LogEntry
  factory LogEntry.fromScanResult(ScanResult scan, {required String disposalLocation}) {
    return LogEntry(
      imageUrl: scan.imageUrl ?? 'assets/images/placeholder-item.png',
      title: scan.productName,
      wasteType: scan.classification,
      timestamp: scan.timestamp ?? DateTime.now(),
      productInfo: 'Product scanned via AI classification.',
      productProperties: scan.materials.map((m) => 'Material: $m').toList(),
      disposalGuideToDo: scan.toDo,
      disposalGuideNotToDo: scan.notToDo,
      disposalGuideProTip: scan.proTip,
      disposalLocation: disposalLocation,
      notes: scan.notes.isNotEmpty ? scan.notes : null,
      quantity: scan.qty > 0 ? scan.qty.toString() : null,
    );
  }

  /// Converts this LogEntry back into a ScanResult
  ScanResult toScanResult() {
    return ScanResult(
      productName: title,
      prodInfo: productInfo,
      materials: productProperties
          .where((p) => p.startsWith('Material:'))
          .map((p) => p.replaceFirst('Material: ', ''))
          .toList(),
      classification: wasteType,
      toDo: disposalGuideToDo,
      notToDo: disposalGuideNotToDo,
      proTip: disposalGuideProTip,
      notes: notes ?? '',
      qty: int.tryParse(quantity ?? '') ?? 1,
      timestamp: timestamp,
      imageUrl: imageUrl,
    );
  }
}
