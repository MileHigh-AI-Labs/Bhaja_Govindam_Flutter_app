class Shloka {
  final String shlokaNo;
  final String devanagari;
  final String transliteration;
  final String wordToWordMeaning;
  final String commentary;

  Shloka({
    required this.shlokaNo,
    required this.devanagari,
    required this.transliteration,
    required this.wordToWordMeaning,
    required this.commentary,
  });

  // This factory constructor creates a Shloka from JSON
  factory Shloka.fromJson(Map<String, dynamic> json) {
    return Shloka(
      shlokaNo: json['Shloka no.'],
      devanagari: json['Devanagari'],
      // Note: There is a space before 'Transliteration' in your JSON file
      transliteration: json[' Transliteration'],
      wordToWordMeaning: json['Word-to-Word Meaning'],
      commentary: json['Commentary'],
    );
  }
}