import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert' as convert;

import 'package:url_launcher/url_launcher.dart';
import 'package:find_groove_flutter/classes.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Ads.initialize();
  AppTrackingTransparency.requestTrackingAuthorization();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Groove',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red[800],
      ),
      home: const MyHomePage(title: 'Find Groove'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.ground17.search-music/process');
  final bannerAd = Ads.createBannerAd();

  String _batteryLevel = 'Unknown battery level.';
  Future<void> _getBatteryLevel() async {String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    Ads.showBannerAd(bannerAd);
  }

  @override
  void dispose() {
    Ads.hideBannerAd(bannerAd);
    super.dispose();
  }

  void _incrementCounter() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(onPressed: _incrementCounter, icon: const Icon(Icons.mic_outlined)),
            const Text(
              'You have pushed the button this many times:',
            ),
            Container(
              alignment: Alignment.center,
              child: AdWidget(ad: bannerAd),
              width: bannerAd.size.width.toDouble(),
              height: bannerAd.size.height.toDouble(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _launchURL() async {
    if (!await launch("https://github.com/Ground17/find_groove")) throw 'Could not launch github.';
  }
}
