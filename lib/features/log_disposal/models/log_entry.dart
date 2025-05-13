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
}
enum WasteType {
  recyclable,
  biodegradable,
  ewaste,
  nonBiodegradable,
}



final List<LogEntry> logEntry = [
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Coca-Cola Glass Bottle 100ml',
    wasteType: 'Recyclable',
    timestamp: DateTime.now(),
    productInfo: 'A small glass bottle used for Coca-Cola beverages.',
    productProperties: [
      'Material: Glass',
      'Capacity: 100ml',
      'Lightweight and recyclable',
    ],
    disposalGuideToDo: [
      'Rinse the bottle',
      'Remove caps or corks',
      'Sort by color if required',
    ],
    disposalGuideNotToDo: [
      'Do not mix with non-recyclables',
      'Avoid contamination with food waste',
    ],
    disposalGuideProTip: 'Glass is endlessly recyclable without losing quality!',
    disposalLocation: 'Recycling Center A, Main Street',
        notes: 'Handle with care to avoid breakage.', // Example notes
    quantity: '5', // Example quantity
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Pepsi Plastic Bottle 1L',
    wasteType: 'Recyclable',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    productInfo: 'A 1-liter plastic bottle used for Pepsi beverages.',
    productProperties: [
      'Material: Plastic', // Only material-related details
    ],
    disposalGuideToDo: [
      'Rinse the bottle',
      'Remove the label and cap',
      'Crush the bottle to save space',
    ],
    disposalGuideNotToDo: [
      'Do not burn the plastic',
      'Avoid mixing with glass or metal waste',
    ],
    disposalGuideProTip: 'Recycling plastic reduces pollution and saves energy!',
    disposalLocation: 'Recycling Center B, Green Avenue',
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Sprite Aluminum Can 250ml',
    wasteType: 'Recyclable',
    timestamp: DateTime.now(),
    productInfo: 'A small aluminum can used for Sprite beverages.',
    productProperties: [
      'Material: Aluminum',
      'Capacity: 250ml',
      'Lightweight and recyclable',
    ],
    disposalGuideToDo: [
      'Rinse the can',
      'Crush the can to save space',
      'Place in metal recycling bins',
    ],
    disposalGuideNotToDo: [
      'Do not mix with food waste',
      'Avoid throwing in general trash',
    ],
    disposalGuideProTip: 'Aluminum is 100% recyclable and can be reused endlessly!',
    disposalLocation: 'Recycling Center C, Eco Park',
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Old Newspaper Bundle',
    wasteType: 'Biodegradable',
    timestamp: DateTime(2025, 4, 1),
    productInfo: 'A bundle of old newspapers ready for recycling.',
    productProperties: [
      'Material: Paper',
      'Reusable and recyclable',
      'Biodegradable',
    ],
    disposalGuideToDo: [
      'Tie the newspapers into bundles',
      'Keep them dry',
      'Drop them off at paper recycling centers',
    ],
    disposalGuideNotToDo: [
      'Do not mix with wet waste',
      'Avoid tearing into small pieces',
    ],
    disposalGuideProTip: 'Recycling paper saves trees and reduces landfill waste!',
    disposalLocation: 'Paper Recycling Center, Maple Street',
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Old Smartphone',
    wasteType: 'E-Waste',
    timestamp: DateTime(2025, 5, 1),
    productInfo: 'An old smartphone ready for e-waste recycling.',
    productProperties: [
      'Material: Plastic and Metal',
      'Contains electronic components',
      'Non-biodegradable',
    ],
    disposalGuideToDo: [
      'Remove personal data',
      'Take to an authorized e-waste recycler',
      'Ensure proper handling of batteries',
    ],
    disposalGuideNotToDo: [
      'Do not throw in general trash',
      'Avoid dismantling without proper tools',
    ],
    disposalGuideProTip: 'Recycling e-waste prevents hazardous materials from harming the environment!',
    disposalLocation: 'E-Waste Recycling Center, Tech Park',
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Reusable Water Bottle',
    wasteType: 'Non-Biodegradable',
    timestamp: DateTime(2025, 5, 1),
    productInfo: 'A reusable water bottle made of durable plastic.',
    productProperties: [
      'Material: Plastic',
      'Capacity: 500ml',
      'Reusable and recyclable',
    ],
    disposalGuideToDo: [
      'Clean the bottle thoroughly',
      'Check if it can be reused',
      'Recycle in plastic bins if damaged',
    ],
    disposalGuideNotToDo: [
      'Do not throw in general trash',
      'Avoid mixing with glass or metal waste',
    ],
    disposalGuideProTip: 'Reusing water bottles reduces waste and saves resources!',
    disposalLocation: 'Recycling Center D, Ocean Drive',
  ),
];
