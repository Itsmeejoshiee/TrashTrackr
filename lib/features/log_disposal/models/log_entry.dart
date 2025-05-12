/// A model class representing a single log entry (e.g., trash pickup or disposal record).
class LogEntry {
  final String imageUrl; // Added imageUrl property
  final String title;
  final String wasteType;
  final DateTime timestamp;

  LogEntry({
    required this.imageUrl, // Required imageUrl in the constructor
    required this.title,
    required this.wasteType,

    required this.timestamp,
  });


  // For Firebase integration later:
  // Uncomment and use this factory when reading entries from Firestore.
  /*
  factory LogEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LogEntry(
      imageUrl: data['imageUrl'],
      title: data['title'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      wasteType: data['wasteType'],
      status: data['status'],
    ;
  }
  */
  // Example list of log entries


}
final List<LogEntry> logEntry = [
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Coca-cola Glass 100 ml',
    timestamp: DateTime.now(),
    wasteType: 'E-Waste',
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Pepsi Bottle 1L',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    wasteType: 'Recycle',
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Sprite Can 250ml',
    timestamp: DateTime.now(),
    wasteType: 'Non-biodegradable',
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Old Newspaper Bundle',
    timestamp: DateTime(2025, 4, 1),
    wasteType: 'Biodegradable',
  ),
  LogEntry(
    imageUrl: 'assets/images/placeholder-item.png',
    title: 'Roaring Water Bottle',
    timestamp: DateTime(2025, 5, 1),
    wasteType: 'Non-biodegradable',
  ),
];