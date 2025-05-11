class ScanResult {
  final String productName;
  final List<String> materials;
  final String classification;
  final List<String> toDo;
  final List<String> notToDo;
  final String proTip;

  ScanResult({
    required this.productName,
    required this.materials,
    required this.classification,
    required this.toDo,
    required this.notToDo,
    required this.proTip,
  });

  // pares from Gemini's raw text response
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
}
