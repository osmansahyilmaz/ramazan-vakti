import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';
import 'surah_detail_screen.dart';

class QuranListScreen extends StatelessWidget {
  const QuranListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Kur'an-ı Kerim", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text("Ramazan Vakti Pro", style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
                    ],
                  ),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.settings, color: AppTheme.textGrey))
                ],
              ),
            ),
            
            // Last Read Card (Static Placeholder for MVP)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAgf1iAnwSj7VB2BokUzPH8-jv7cyk2Z41qMkvACzGqUvF2U-FaexCtFGiILfAOla5GCE96bliVPEVLNJWT5T74De1xITayKGLmF2DLyz1gxhck77LnwTTBdwte7SKo7mDsv2h1q-wvt3Rlz0pg3mn9Zg2iJO0rIRkhdn4Fr8zN0dmEaOZHsITHMKj8Wcq3bPQLDXpB9_QIztETnhyARKau9MtoP-4pfybuvJZm0EZDeVNa3QTqyQ7jirfHYu6J-oyb5TNB4T2Q9bk'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken)
                ),
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [Icon(Icons.history, size: 14, color: AppTheme.primary), SizedBox(width: 4), Text("SON OKUNAN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primary))],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Bakara Suresi", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text("Ayet: 255 (Ayet-el Kürsi)", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                            const CircleAvatar(backgroundColor: AppTheme.primary, child: Icon(Icons.arrow_forward, color: Colors.white))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppTheme.surfaceDark,
                  hintText: "Sure Ara...",
                  hintStyle: const TextStyle(color: AppTheme.textGrey),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textGrey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14)
                ),
              ),
            ),

            const SizedBox(height: 10),

            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
                itemCount: 114,
                itemBuilder: (context, index) {
                  final surahNumber = index + 1;
                  return _buildSurahTile(context, surahNumber);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSurahTile(BuildContext context, int number) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SurahDetailScreen(surahNumber: number)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(image: NetworkImage("https://cdn-icons-png.flaticon.com/512/7299/7299632.png"), opacity: 0.1) // Star shape placeholder
              ),
              child: Text("$number", style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quran.getSurahNameTurkish(number), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(quran.getPlaceOfRevelation(number) == 'Makkah' ? 'Mekke' : 'Medine', style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                      const SizedBox(width: 6),
                      const CircleAvatar(radius: 2, backgroundColor: Colors.grey),
                      const SizedBox(width: 6),
                      Text("${quran.getVerseCount(number)} Ayet", style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                    ],
                  )
                ],
              ),
            ),
            Text(quran.getSurahNameArabic(number), style: const TextStyle(fontFamily: 'Amiri', fontSize: 20, color: AppTheme.primary)),
          ],
        ),
      ),
    );
  }
}
