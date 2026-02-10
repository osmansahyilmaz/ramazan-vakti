import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/theme/app_theme.dart';

// State for the counter
final counterProvider = StateProvider<int>((ref) => 0);
final targetProvider = StateProvider<int>((ref) => 33);

class DuasScreen extends ConsumerWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final target = ref.watch(targetProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.transparent), // invisible for balance
                  const Text("Dualar ve Zikirler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Icon(Icons.settings, color: Colors.white),
                ],
              ),
            ),
            
            // Toggle Segment (Visual only for MVP structure)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(child: Center(child: Text("Dualar", style: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.w500)))),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
                      child: const Center(child: Text("Tesbih", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Targets
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [33, 99, 999].map((val) => 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () => ref.read(targetProvider.notifier).state = val,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: target == val ? AppTheme.primary.withOpacity(0.2) : AppTheme.surfaceDark,
                        border: Border.all(color: target == val ? AppTheme.primary : Colors.transparent),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text("$val", style: TextStyle(color: target == val ? AppTheme.primary : AppTheme.textGrey, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ).toList(),
            ),

            const SizedBox(height: 30),

            // Counter Circle
            GestureDetector(
              onTap: () {
                ref.read(counterProvider.notifier).state++;
                // Haptic feedback could be added here
              },
              child: Container(
                width: 250, height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceDark,
                  border: Border.all(color: AppTheme.surfaceDarker, width: 8),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primary.withOpacity(0.05), blurRadius: 40, spreadRadius: 10)
                  ]
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: count % target == 0 && count != 0 ? 1 : (count % target) / target,
                      strokeWidth: 4,
                      color: AppTheme.primary,
                      backgroundColor: Colors.transparent,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("SAYAÇ", style: TextStyle(fontSize: 12, letterSpacing: 2, color: AppTheme.textGrey)),
                        Text("$count", style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w200, color: Colors.white)),
                        const Text("Sübhânallah", style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlBtn(Icons.volume_up, "SES", () {}),
                _buildControlBtn(Icons.fingerprint, "ZİKİR", () => ref.read(counterProvider.notifier).state++, isPrimary: true),
                _buildControlBtn(Icons.refresh, "SIFIRLA", () => ref.read(counterProvider.notifier).state = 0),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBtn(IconData icon, String label, VoidCallback onTap, {bool isPrimary = false}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: isPrimary ? 80 : 60,
            height: isPrimary ? 80 : 60,
            decoration: BoxDecoration(
              color: isPrimary ? AppTheme.primary : AppTheme.surfaceDark,
              shape: isPrimary ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isPrimary ? BorderRadius.circular(20) : null,
              boxShadow: isPrimary ? [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 20)] : [],
            ),
            child: Icon(icon, color: isPrimary ? Colors.white : AppTheme.textGrey, size: isPrimary ? 40 : 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textGrey)),
      ],
    );
  }
}
