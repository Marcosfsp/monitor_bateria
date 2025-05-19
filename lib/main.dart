import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monitor de Bateria',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BatteryMonitorPage(),
    );
  }
}

class BatteryMonitorPage extends StatefulWidget {
  @override
  _BatteryMonitorPageState createState() => _BatteryMonitorPageState();
}

class _BatteryMonitorPageState extends State<BatteryMonitorPage> {
  final Battery _battery = Battery();
  int _batteryLevel = 100;

  @override
  void initState() {
    super.initState();
    _checkBatteryLevel();
  }

  Future<void> _checkBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });

    if (level < 20) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ Bateria fraca: $_batteryLevel%'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  Future<void> _openGitHubProfile() async {
    final url = Uri.parse('https://github.com/Marcosfsp');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monitor de Bateria')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nível da bateria: $_batteryLevel%'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openGitHubProfile,
              child: Text('Visite meu GitHub'),
            ),
          ],
        ),
      ),
    );
  }
}
