enum EventType {
  cleanUp('clean-up'),
  donation('donation drive'),
  workshop('workshop'),
  other('other');

  final String name;

  const EventType(this.name);

  static EventType fromString(String s) => switch (s) {
    'clean-up' => cleanUp,
    'donation drive' => donation,
    'workshop' => workshop,
    'other' => other,
    _ => other,
  };

}