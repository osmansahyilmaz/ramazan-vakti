import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box('settings').listenable(),
          builder: (context, Box box, _) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Header
                Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white),
                    const SizedBox(width: 16),
                    const Text("Ayarlar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Spacer(),
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppTheme.primary, Colors.blue])),
                      child: const Icon(Icons.person, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 30),

                // Location Section
                const _SectionHeader("KONUM SEÇİMİ"),
                Container(
                  decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.near_me, color: AppTheme.primary)),
                        title: const Text("Mevcut Konum", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: const Text("İstanbul, Türkiye", style: TextStyle(color: AppTheme.primary, fontSize: 12)),
                        trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
                      ),
                      const Divider(height: 1, color: Colors.white10),
                      SwitchListTile(
                        activeColor: AppTheme.primary,
                        title: const Text("Otomatik GPS", style: TextStyle(color: Colors.white)),
                        secondary: const Icon(Icons.gps_fixed, color: Colors.blue),
                        value: box.get('auto_gps', defaultValue: true),
                        onChanged: (val) => box.put('auto_gps', val),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Notifications
                const _SectionHeader("BİLDİRİMLER"),
                Container(
                  decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _buildSwitch(box, 'notify_fajr', 'İmsak / Sabah', true),
                      _buildSwitch(box, 'notify_dhuhr', 'Öğle', true),
                      _buildSwitch(box, 'notify_asr', 'İkindi', false),
                      _buildSwitch(box, 'notify_maghrib', 'Akşam / İftar', true),
                      _buildSwitch(box, 'notify_isha', 'Yatsı', true),
                      Container(color: AppTheme.backgroundDark, height: 30, width: double.infinity, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 16), child: const Text("RAMAZAN ÖZEL", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold))),
                      SwitchListTile(
                        activeColor: AppTheme.primary,
                        title: const Text("Sahur Uyarıcısı", style: TextStyle(color: Colors.white)),
                        subtitle: const Text("İmsaktan 30 dk önce", style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                        value: box.get('notify_sahur', defaultValue: true),
                        onChanged: (val) => box.put('notify_sahur', val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Preferences
                const _SectionHeader("TERCİHLER"),
                Container(
                  decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                       ListTile(
                        leading: const Icon(Icons.calendar_today, color: Colors.purpleAccent),
                        title: const Text("Hicri Takvim Ayarı", style: TextStyle(color: Colors.white)),
                        subtitle: const Text("Gün düzeltme (±1)", style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.remove, color: Colors.white), onPressed: () {
                               int current = box.get('hijri_offset', defaultValue: 0);
                               box.put('hijri_offset', current - 1);
                            }),
                            Text("${box.get('hijri_offset', defaultValue: 0)}", style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                            IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () {
                               int current = box.get('hijri_offset', defaultValue: 0);
                               box.put('hijri_offset', current + 1);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const Center(child: Text("Ramazan Vakti Pro v1.0.0", style: TextStyle(color: AppTheme.textGrey, fontSize: 12))),
                const Center(child: Text("Ümmet için ❤️ ile yapıldı", style: TextStyle(color: AppTheme.textGrey, fontSize: 10))),
                const SizedBox(height: 100),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildSwitch(Box box, String key, String title, bool def) {
    return SwitchListTile(
      activeColor: AppTheme.primary,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: box.get(key, defaultValue: def),
      onChanged: (val) => box.put(key, val),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(title, style: const TextStyle(color: AppTheme.textGrey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }
}
