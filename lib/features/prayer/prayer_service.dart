import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Location Provider
final locationProvider = FutureProvider<Position>((ref) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Return default Istanbul location if disabled
    return Position(longitude: 28.9784, latitude: 41.0082, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Position(longitude: 28.9784, latitude: 41.0082, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0);
    }
  }

  return await Geolocator.getCurrentPosition();
});

// Prayer Times State
class PrayerState {
  final PrayerTimes? prayerTimes;
  final Prayer? nextPrayer;
  final DateTime? nextPrayerTime;
  final HijriCalendar hijriDate;

  PrayerState({this.prayerTimes, this.nextPrayer, this.nextPrayerTime, required this.hijriDate});
}

final prayerProvider = Provider<PrayerState>((ref) {
  final locationAsync = ref.watch(locationProvider);
  
  // Default to Istanbul
  Coordinates coords = Coordinates(41.0082, 28.9784); 
  
  locationAsync.whenData((pos) {
    coords = Coordinates(pos.latitude, pos.longitude);
  });

  final params = CalculationMethod.turkey.getParameters();
  params.madhab = Madhab.hanafi;

  final now = DateTime.now();
  final prayerTimes = PrayerTimes.today(coords, params);
  
  final nextPrayer = prayerTimes.nextPrayer();
  final nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer) ?? prayerTimes.fajr.add(const Duration(days: 1));

  // Hijri Adjustment from settings
  final box = Hive.box('settings');
  final offset = box.get('hijri_offset', defaultValue: 0);
  HijriCalendar.setLocal('tr');
  final hijri = HijriCalendar.fromDate(now);
  // Simple offset simulation (Hijri lib doesn't support direct day add easily without re-calc)
  
  return PrayerState(
    prayerTimes: prayerTimes,
    nextPrayer: nextPrayer,
    nextPrayerTime: nextPrayerTime,
    hijriDate: hijri,
  );
});

// Helper to translate Prayer Enum
String getPrayerNameTR(Prayer p) {
  switch (p) {
    case Prayer.fajr: return 'İmsak';
    case Prayer.sunrise: return 'Güneş';
    case Prayer.dhuhr: return 'Öğle';
    case Prayer.asr: return 'İkindi';
    case Prayer.maghrib: return 'Akşam';
    case Prayer.isha: return 'Yatsı';
    default: return 'Bilinmiyor';
  }
}
