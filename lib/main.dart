import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Chapters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChapterListScreen(),
    );
  }
}

class ChapterListScreen extends StatefulWidget {
  @override
  _ChapterListScreenState createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  List<Chapter> chapterList = [];

  @override
  void initState() {
    super.initState();
    loadChapters();
  }

  Future<void> loadChapters() async {
    String chapterJsonString =
        await rootBundle.loadString('assets/chapter.json');
    List<dynamic> chapterJson = json.decode(chapterJsonString);

    setState(() {
      chapterList = chapterJson.map((json) => Chapter.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Chapters'),
      ),
      body: ListView.builder(
        itemCount: chapterList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              chapterList[index].name,
              style: TextStyle(color: const Color.fromARGB(255, 100, 23, 0)),
            ),
            subtitle: Text(
              chapterList[index].transliteration,
              style: TextStyle(color: const Color.fromARGB(255, 100, 23, 0)),
            ),
            tileColor: Color.fromARGB(255, 255, 255, 255),
            onTap: () async {
              // Updated: Load verses when a Surah is tapped
              List<Verse> verses = await loadVerses(chapterList[index].id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(
                    surah: Surah(
                      chapterList[index].id,
                      chapterList[index].name,
                      '', // Add appropriate values for transliteration and type
                      chapterList[index].type,
                      chapterList[index].totalVerses,
                      verses, // Pass the loaded verses
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Updated: Load verses for a given Surah ID
  Future<List<Verse>> loadVerses(int surahId) async {
    String quranJsonString = await rootBundle.loadString('assets/quran.json');
    List<dynamic> quranJson = json.decode(quranJsonString);

    // Find the Surah by ID in quranJson
    Map<String, dynamic>? surahJson = quranJson.firstWhere(
      (json) => json['id'] == surahId,
      orElse: () => null,
    );

    if (surahJson != null) {
      // Load verses for the found Surah
      List<dynamic> versesJson = surahJson['verses'] ?? [];
      List<Verse> verses = versesJson.map((v) => Verse.fromJson(v)).toList();
      return verses;
    } else {
      return [];
    }
  }
}

class SurahDetailScreen extends StatelessWidget {
  final Surah surah;

  SurahDetailScreen({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.name),
      ),
      body: ListView.builder(
        itemCount: surah.verses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(surah.verses[index].text),
          );
        },
      ),
    );
  }
}
