/// A model class representing a single log entry (e.g., trash pickup or disposal record).
class LogEntry {
  /// URL or asset path of the image associated with the log entry.
  final String imageUrl;

  /// Title or description of the log entry (e.g., "Collected plastic bottles").
  final String title;

  /// Date and time when the log entry was created.
  final DateTime timestamp;

  /// The type of waste (e.g., "Recycle", "Biodegradable", etc.).
  final String wasteType;

  /// The current status of the entry (e.g., "Collected", "Pending").
  final String status;

  /// Constructor requiring all fields to be provided when creating a LogEntry instance.
  LogEntry({
    required this.imageUrl,
    required this.title,
    required this.timestamp,
    required this.wasteType,
    required this.status,
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
    );
  }
  */
}
