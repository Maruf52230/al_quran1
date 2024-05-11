
class Chapter {
  final int id;
  final String name;
  final String transliteration;
  final String type;
  final int totalVerses;

  Chapter(
      this.id, this.name, this.type, this.totalVerses, this.transliteration);

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      json['id'],
      json['name'],
      json['type'],
      json['total_verses'],
      json['transliteration'],
    );
  }
}

class Surah {
  final int id;
  final String name;
  final String transliteration;
  final String type;
  final int totalVerses;
  List<Verse> verses; // Updated: Declare verses list here

  Surah(this.id, this.name, this.transliteration, this.type, this.totalVerses,
      this.verses); // Updated: Include verses in the constructor

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      json['id'],
      json['name'],
      json['transliteration'],
      json['type'],
      json['total_verses'],
      [], // Initialize verses as an empty list
    );
  }
}

class Verse {
  final int id;
  final String text;

  Verse({required this.id, required this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'],
      text: json['text'],
    );
  }
}
