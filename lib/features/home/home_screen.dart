import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../prayer/prayer_dashboard_screen.dart';
import '../quran/quran_list_screen.dart';
import '../duas/duas_screen.dart';
import '../qibla/qibla_screen.dart';
import '../settings/settings_screen.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);

    final screens = const [
      PrayerDashboardScreen(),
      QuranListScreen(),
      QiblaScreen(), // Middle button logic handles this separately in UI but standard logic here
      DuasScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Using IndexedStack to preserve state of tabs
          IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(context, ref, currentIndex),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, WidgetRef ref, int currentIndex) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        items: [
          _NavItem(icon: Icons.schedule, label: 'Vakitler', index: 0, isSelected: currentIndex == 0, onTap: () => ref.read(navIndexProvider.notifier).state = 0),
          _NavItem(icon: Icons.menu_book, label: 'Kur\'an', index: 1, isSelected: currentIndex == 1, onTap: () => ref.read(navIndexProvider.notifier).state = 1),
          // Qibla Button (Floating look)
          _QiblaNavItem(isSelected: currentIndex == 2, onTap: () => ref.read(navIndexProvider.notifier).state = 2),
          _NavItem(icon: Icons.volunteer_activism, label: 'Dualar', index: 3, isSelected: currentIndex == 3, onTap: () => ref.read(navIndexProvider.notifier).state = 3),
          _NavItem(icon: Icons.settings, label: 'Ayarlar', index: 4, isSelected: currentIndex == 4, onTap: () => ref.read(navIndexProvider.notifier).state = 4),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.index, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? AppTheme.primary : AppTheme.textGrey, size: 26),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? AppTheme.primary : AppTheme.textGrey, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _QiblaNavItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _QiblaNavItem({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 25), // Lift it up
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.backgroundDark, width: 4),
          boxShadow: [
            BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: const Icon(Icons.explore, color: Colors.white, size: 30),
      ),
    );
  }
}
