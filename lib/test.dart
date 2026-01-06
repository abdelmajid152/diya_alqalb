import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:flutter_compass/flutter_compass.dart';

void main() {
  runApp(const PrayerApp());
}

class PrayerApp extends StatelessWidget {
  const PrayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'DINNextLTArabic', // تأكد من إضافة خط عربي أو حذف هذا السطر
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // متغيرات البيانات
  Map<String, dynamic>? prayerTimes;
  double? qiblaDirection; // زاوية القبلة من الـ API
  bool isLoading = true;
  String errorMessage = "";

  // متغيرات العد التنازلي
  String nextPrayerName = "---";
  Duration timeUntilNextPrayer = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 1. الدالة الرئيسية لجلب الموقع والبيانات
  Future<void> _initializeData() async {
    try {
      Position position = await _determinePosition();

      // جلب المواقيت
      await _fetchPrayerTimes(position.latitude, position.longitude);

      // جلب اتجاه القبلة
      await _fetchQiblaDirection(position.latitude, position.longitude);

      // بدء المؤقت للعد التنازلي
      _startTimer();

    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // الحصول على الموقع والصلاحيات
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'خدمة الموقع غير مفعلة.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'تم رفض إذن الوصول للموقع.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'إذن الموقع مرفوض بشكل دائم.';
    }

    return await Geolocator.getCurrentPosition();
  }

  // جلب المواقيت من API
  Future<void> _fetchPrayerTimes(double lat, double long) async {
    final String date = intl.DateFormat('dd-MM-yyyy').format(DateTime.now());
    // method=8 (أم القرى)
    final url = "https://api.aladhan.com/v1/timings/$date?latitude=$lat&longitude=$long&method=8";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        prayerTimes = data['data']['timings'];
        isLoading = false; // البيانات الأساسية وصلت
      });
    } else {
      throw 'فشل في جلب المواقيت';
    }
  }

  // جلب زاوية القبلة من API
  Future<void> _fetchQiblaDirection(double lat, double long) async {
    final url = "http://api.aladhan.com/v1/qibla/$lat/$long";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        qiblaDirection = data['data']['direction'];
      });
    }
  }

  // حساب الصلاة القادمة
  void _calculateNextPrayer() {
    if (prayerTimes == null) return;

    DateTime now = DateTime.now();
    List<String> prayers = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    Map<String, String> arabicNames = {
      'Fajr': 'الفجر', 'Sunrise': 'الشروق', 'Dhuhr': 'الظهر',
      'Asr': 'العصر', 'Maghrib': 'المغرب', 'Isha': 'العشاء'
    };

    String? upcomingPrayerCode;
    DateTime? upcomingPrayerTime;

    for (var prayerCode in prayers) {
      String timeStr = prayerTimes![prayerCode].split(" ")[0]; // إزالة (EST)
      List<String> parts = timeStr.split(":");
      DateTime pTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));

      if (pTime.isAfter(now)) {
        upcomingPrayerCode = prayerCode;
        upcomingPrayerTime = pTime;
        break;
      }
    }

    // إذا انتهت صلوات اليوم، القادمة هي الفجر غداً
    if (upcomingPrayerCode == null) {
      upcomingPrayerCode = 'Fajr';
      String timeStr = prayerTimes!['Fajr'].split(" ")[0];
      List<String> parts = timeStr.split(":");
      upcomingPrayerTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]))
          .add(const Duration(days: 1));
    }

    setState(() {
      nextPrayerName = arabicNames[upcomingPrayerCode] ?? upcomingPrayerCode!;
      timeUntilNextPrayer = upcomingPrayerTime!.difference(now);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateNextPrayer();
    });
  }

  // واجهة التطبيق
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("مواقيت الصلاة"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () {
              if (qiblaDirection != null) {
                // فتح القبلة في نافذة منبثقة
                showModalBottomSheet(
                    context: context,
                    builder: (context) => QiblaCompass(qiblaDirection: qiblaDirection!)
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("جاري تحديد موقع القبلة... انتظر قليلاً"))
                );
              }
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
          : Column(
        children: [
          // قسم العد التنازلي
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.teal,
            child: Column(
              children: [
                const Text("الصلاة القادمة", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 5),
                Text(nextPrayerName, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  "${timeUntilNextPrayer.inHours.toString().padLeft(2, '0')}:${(timeUntilNextPrayer.inMinutes % 60).toString().padLeft(2, '0')}:${(timeUntilNextPrayer.inSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontFamily: "monospace"),
                ),
              ],
            ),
          ),

          // قائمة الصلوات
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                _buildTile("الفجر", prayerTimes?['Fajr']),
                _buildTile("الشروق", prayerTimes?['Sunrise']),
                _buildTile("الظهر", prayerTimes?['Dhuhr']),
                _buildTile("العصر", prayerTimes?['Asr']),
                _buildTile("المغرب", prayerTimes?['Maghrib']),
                _buildTile("العشاء", prayerTimes?['Isha']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String name, String? time) {
    bool isNext = name == nextPrayerName;
    return Card(
      color: isNext ? Colors.teal.shade50 : Colors.white,
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.access_time_filled, color: isNext ? Colors.teal : Colors.grey),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: isNext ? Colors.teal : Colors.black)),
        trailing: Text(time ?? "-", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ---------------------------------------------------------
// ويدجت مستقلة للبوصلة
// ---------------------------------------------------------
// ضروري للاهتزاز

class QiblaCompass extends StatefulWidget {
  final double qiblaDirection;
  const QiblaCompass({super.key, required this.qiblaDirection});

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double? heading = 0;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          heading = event.heading;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (heading == null) {
      return const Center(child: Text("جهازك لا يدعم البوصلة"));
    }

    // 1. حساب الزاوية للدوران
    double angleRadians = (widget.qiblaDirection - heading!) * (math.pi / 180);

    // 2. التحقق مما إذا كان الاتجاه صحيحاً (مع سماحية +/- 3 درجات)
    // نستخدم abs() للحصول على القيمة المطلقة للفرق
    double diff = (widget.qiblaDirection - heading!).abs();

    // معالجة مشكلة الدوران (مثلاً الفرق بين 359 و 1 هو درجتين وليس 358)
    if (diff > 180) diff = 360 - diff;

    bool isAligned = diff < 3;

    // 3. تشغيل الاهتزاز عند المحاذاة (اختياري: لمنع الاهتزاز المستمر يمكن إضافة شرط إضافي)
    if (isAligned) {
      HapticFeedback.selectionClick();
    }

    return Container(
      height: 450, // زدنا الطول قليلاً
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Text(
            isAligned ? "القبلة صحيحة ✅" : "ابحث عن القبلة...",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isAligned ? Colors.green : Colors.grey
            ),
          ),
          const SizedBox(height: 30),

          Stack(
            alignment: Alignment.center,
            children: [
              // خلفية البوصلة
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isAligned ? Colors.green : Colors.grey.shade300,
                      width: isAligned ? 4 : 2
                  ),
                  boxShadow: isAligned
                      ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)]
                      : [],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // علامة صغيرة تدل على مقدمة الهاتف
                    Icon(Icons.arrow_drop_up, color: isAligned ? Colors.green : Colors.grey),
                  ],
                ),
              ),

              // سهم القبلة
              Transform.rotate(
                angle: -angleRadians, // تدوير السهم
                child: Icon(
                    Icons.navigation,
                    size: 100,
                    // تغيير لون السهم للأخضر عند الوصول
                    color: isAligned ? Colors.green : Colors.teal
                ),
              ),

              // أيقونة الكعبة (صورة تعبيرية في الوسط أو سهم ثابت)
              if (isAligned)
                const Positioned(
                  top: 60,
                  child: Icon(Icons.mosque, size: 40, color: Colors.green),
                )
            ],
          ),

          const Spacer(),
          Text(
            "زاوية القبلة: ${widget.qiblaDirection.toStringAsFixed(1)}°",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "اتجاه هاتفك: ${heading!.toStringAsFixed(1)}°",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}






