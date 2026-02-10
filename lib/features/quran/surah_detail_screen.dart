import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:just_audio/just_audio.dart';
import '../../core/theme/app_theme.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudio();
  }
  
  Future<void> _loadAudio() async {
    // Using a public Quran audio API
    final url = quran.getAudioURLBySurah(widget.surahNumber);
    await _audioPlayer.setUrl(url);
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: Column(
          children: [
            Text(quran.getSurahNameTurkish(widget.surahNumber), style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(quran.getSurahNameArabic(widget.surahNumber), style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontFamily: 'Amiri')),
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          // Basmala
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Text(quran.basmala, style: TextStyle(fontFamily: 'Amiri', fontSize: 24, color: Colors.white), textAlign: TextAlign.center),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: quran.getVerseCount(widget.surahNumber),
              itemBuilder: (context, index) {
                final verseNum = index + 1;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white10))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 14, 
                            backgroundColor: AppTheme.primary.withOpacity(0.1),
                            child: Text("$verseNum", style: const TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.share, size: 18, color: AppTheme.textGrey),
                              SizedBox(width: 10),
                              Icon(Icons.bookmark_border, size: 18, color: AppTheme.textGrey),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        quran.getVerse(widget.surahNumber, verseNum),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontFamily: 'Amiri', fontSize: 22, height: 2.0, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        quran.getVerseTranslation(widget.surahNumber, verseNum, translation: quran.Translation.trSaheeh),
                        style: const TextStyle(fontSize: 14, color: AppTheme.textGrey, height: 1.5),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Player Control
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.skip_previous, size: 30)),
                FloatingActionButton(
                  backgroundColor: AppTheme.primary,
                  onPressed: () {
                    if (isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.play();
                    }
                  },
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 30),
                ),
                IconButton(onPressed: (){}, icon: const Icon(Icons.skip_next, size: 30)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
