import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_theme.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (_, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Hata oluştu. Lütfen GPS kontrol edin.", style: TextStyle(color: Colors.white)));
          }

          if (snapshot.data == true) {
            return _buildCompass();
          } else {
            return _buildMapFallback();
          }
        },
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) return const SizedBox();

        // Calculations for UI rotation
        final direction = qiblahDirection.qiblah;
        final angle = ((direction) * (pi / 180) * -1);

        return SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back_ios, color: Colors.white),
                    const Text("Kıble Bulucu", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Icon(Icons.settings, color: Colors.white),
                  ],
                ),
              ),

              // Location Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.near_me, color: AppTheme.primary, size: 16),
                    SizedBox(width: 8),
                    Text("İstanbul, Türkiye", style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(width: 8),
                    Text("•", style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 8),
                    Text("Yüksek Hassasiyet", style: TextStyle(color: AppTheme.primary, fontSize: 12)),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Compass Dial
                      Transform.rotate(
                        angle: angle,
                        child: Container(
                          width: 300, height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.surfaceDark, AppTheme.surfaceDarker]),
                            border: Border.all(color: Colors.white10),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
                          ),
                          child: Stack(
                            children: [
                              // North
                              Align(alignment: Alignment.topCenter, child: Padding(padding: const EdgeInsets.all(10), child: Text("K", style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)))),
                              // Kaaba Icon in correct direction relative to north (mock visualization)
                              // In real app, the needle points to Qibla, here we rotate the whole dial
                            ],
                          ),
                        ),
                      ),
                      
                      // Needle (Fixed pointing up)
                      Container(
                        width: 4, height: 100,
                        margin: const EdgeInsets.only(bottom: 100),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.6), blurRadius: 10)]
                        ),
                      ),
                      
                      // Center Pivot
                      Container(width: 16, height: 16, decoration: const BoxDecoration(color: AppTheme.surfaceDark, shape: BoxShape.circle)),
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
                    ],
                  ),
                ),
              ),

              // Info Text
              Text("${direction.toInt()}° GD", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: Colors.white)),
              const SizedBox(height: 8),
              const Text("Kabe 2.450 km uzaklıkta", style: TextStyle(color: AppTheme.textGrey)),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapFallback() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 64, color: AppTheme.textGrey),
          SizedBox(height: 16),
          Text("Pusula sensörü bulunamadı.", style: TextStyle(color: Colors.white)),
          Text("Lütfen harita modunu kullanın (Map implementation placeholder).", style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
        ],
      ),
    );
  }
}
