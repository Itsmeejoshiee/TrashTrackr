enum Emotion {
  empowered,
  grateful,
  hopeful,
  inspired,
  joyful;

  static Emotion fromString(String s) => switch (s) {
    'empowered' => empowered,
    'grateful' => grateful,
    'hopeful' => hopeful,
    'inspired' => inspired,
    'joyful' => joyful,
    _ => joyful
  };

}