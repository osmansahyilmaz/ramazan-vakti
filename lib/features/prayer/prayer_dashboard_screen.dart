import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import '../../core/theme/app_theme.dart';
import 'prayer_service.dart';

class PrayerDashboardScreen extends ConsumerStatefulWidget {
  const PrayerDashboardScreen({super.key});

  @override
  ConsumerState<PrayerDashboardScreen> createState() => _PrayerDashboardScreenState();
}

class _PrayerDashboardScreenState extends ConsumerState<PrayerDashboardScreen> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final state = ref.read(prayerProvider);
      if (state.nextPrayerTime != null) {
        final now = DateTime.now();
        setState(() {
          _timeLeft = state.nextPrayerTime!.difference(now);
          if (_timeLeft.isNegative) _timeLeft = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(prayerProvider);
    final pt = prayerState.prayerTimes;

    if (pt == null) return const Center(child: CircularProgressIndicator(color: AppTheme.primary));

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(prayerState),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  _buildCountdownCard(prayerState),
                  const SizedBox(height: 24),
                  const Text("BUGÜNÜN VAKİTLERİ", style: TextStyle(color: AppTheme.textGrey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  _buildPrayerTile(Prayer.fajr, pt.fajr, prayerState.nextPrayer),
                  _buildPrayerTile(Prayer.sunrise, pt.sunrise, prayerState.nextPrayer), // Sun
                  _buildPrayerTile(Prayer.dhuhr, pt.dhuhr, prayerState.nextPrayer),
                  _buildPrayerTile(Prayer.asr, pt.asr, prayerState.nextPrayer),
                  _buildPrayerTile(Prayer.maghrib, pt.maghrib, prayerState.nextPrayer),
                  _buildPrayerTile(Prayer.isha, pt.isha, prayerState.nextPrayer),
                  
                  const SizedBox(height: 20),
                  _buildHadithCard(),
                  const SizedBox(height: 100), // Bottom padding for nav
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PrayerState state) {
    final now = DateTime.now();
    final dateStr = DateFormat('d MMMM', 'tr_TR').format(now);
    final dayStr = DateFormat('EEEE', 'tr_TR').format(now);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("RAMAZAN VAKTİ PRO", style: TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: AppTheme.textGrey, size: 14),
                      SizedBox(width: 4),
                      Text("İstanbul, TR", style: TextStyle(color: AppTheme.textGrey, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: AppTheme.textGrey))
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDarker,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                  ),
                  child: const Text("HAYIRLI RAMAZANLAR", style: TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Text("${state.hijriDate.hDay} ${state.hijriDate.longMonthName}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("${state.hijriDate.hYear} H", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: AppTheme.textGrey)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _DateInfoItem(label: "MİLADİ", value: dateStr),
                    Container(width: 1, height: 30, color: Colors.white10),
                    _DateInfoItem(label: "GÜN", value: dayStr),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCountdownCard(PrayerState state) {
    final hours = _timeLeft.inHours.toString().padLeft(2, '0');
    final minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    final nextName = getPrayerNameTR(state.nextPrayer ?? Prayer.none);

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.primary.withOpacity(0.9), AppTheme.primary]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        children: [
          // Background pattern placeholder
          Positioned(right: -20, top: -20, child: Icon(Icons.wb_sunny, size: 150, color: Colors.white.withOpacity(0.1))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.wb_twilight, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text("$nextName'a Kalan Süre", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: hours, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                          const TextSpan(text: " sa ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70)),
                          TextSpan(text: minutes, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                          const TextSpan(text: " dk", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70)),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.3), width: 3)),
                  child: const Center(child: Icon(Icons.restaurant, color: Colors.white)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTile(Prayer p, DateTime time, Prayer? nextPrayer) {
    final isNext = p == nextPrayer;
    final timeStr = DateFormat('HH:mm').format(time);
    final name = getPrayerNameTR(p);

    // Skip Sunrise in "Next Prayer" logic usually, but keep in list
    // Styling
    final bgColor = isNext ? AppTheme.surfaceDarker : AppTheme.surfaceDark;
    final borderColor = isNext ? AppTheme.primary.withOpacity(0.3) : Colors.white.withOpacity(0.05);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isNext ? [BoxShadow(color: AppTheme.primary.withOpacity(0.1), blurRadius: 10)] : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: isNext ? AppTheme.primary : AppTheme.surfaceDarker,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getPrayerIcon(p), 
                  size: 16, 
                  color: isNext ? Colors.white : AppTheme.textGrey
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w600, color: isNext ? Colors.white : AppTheme.textGrey, fontSize: 16)),
                  if (isNext) 
                    const Text("Sıradaki Vakit", style: TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Text(timeStr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isNext ? Colors.white : AppTheme.textGrey)),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(Prayer p) {
    switch (p) {
      case Prayer.fajr: return Icons.wb_twilight;
      case Prayer.sunrise: return Icons.wb_sunny;
      case Prayer.dhuhr: return Icons.light_mode;
      case Prayer.asr: return Icons.wb_sunny_outlined;
      case Prayer.maghrib: return Icons.nights_stay;
      case Prayer.isha: return Icons.dark_mode;
      default: return Icons.access_time;
    }
  }

  Widget _buildHadithCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textGrey.withOpacity(0.2), style: BorderStyle.solid),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: AppTheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Ramazan ayı girdiğinde cennet kapıları açılır, cehennem kapıları kapanır ve şeytanlar zincire vurulur.",
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white70, height: 1.5),
                ),
                SizedBox(height: 8),
                Text("— Sahih-i Buhari", style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DateInfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _DateInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textGrey, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}
