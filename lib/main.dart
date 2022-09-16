import 'dart:isolate';
import 'package:alarme_notificacao/alarme_criacao_page.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'MyOverlayWindow.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:vibration/vibration.dart';
import 'package:workmanager/workmanager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'models/AlarmeProvider.dart';
import 'tela.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import 'dart:ui';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class IsolateManager {
  static String FOREGROUND_PORT_NAME = "";

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_launcher');

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _localNotificationService.initialize(settings,
        onSelectNotification: onSelectNotification);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id_4', 'channel_name',
            channelDescription: 'Descri',
            importance: Importance.high,
            priority: Priority.high,
            fullScreenIntent: true,
            sound: RawResourceAndroidNotificationSound('platermsc'),
            playSound: true);

    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 10)), tz.local),
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  void onSelectNotification(String? payload) {
    navigatorKey.currentState?.pushNamed('/login');
  }
}

Future<void> playLocalAsset() async {
  final player = AudioPlayer();

  await player.play(AssetSource('audios/playLocalAsset.mp3'));
}

const task = 'first';
void callBackDis() async {
  Workmanager().executeTask((taskName, inputData) async {
    Vibration.vibrate(duration: 4000);

    return Future.value(false);
  });
}

void printHello() async {
  AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            channelShowBadge: true,
            importance: NotificationImportance.High)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  String localTimeZone =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      notificationLayout: NotificationLayout.BigText,
      channelKey: 'basic_channel',
      title: 'Simple Notification',
      body: 'Simple body',
      wakeUpScreen: true,
      fullScreenIntent: true,
      criticalAlert: true,
    ),
    schedule: NotificationInterval(
      interval: 10,
      timeZone: localTimeZone,
      preciseAlarm: true,
    ),
    actionButtons: <NotificationActionButton>[
      NotificationActionButton(key: 'yes', label: 'Yes'),
      NotificationActionButton(key: 'no', label: 'No'),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(callBackDis, isInDebugMode: false);
  await AndroidAlarmManager.initialize();
  AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            channelShowBadge: true,
            enableVibration: true,
            playSound: true,
            locked: true,
            // soundSource: "resource://raw/exemplo.m4a",
            enableLights: true,
            importance: NotificationImportance.High)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          NotificationPermission.FullScreenIntent,
        ],
      );
    }
  });

  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home aaa'),
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
  List<Map<String, dynamic>> _alarmes = [];

  /* void _refreshJournals() async {
    final data = await AlarmeProvider.();
    setState(() {
      _alarmes = data;
    });
  }*/

  int _counter = 0;

  void _refreshJournals() async {
    final da = await AlarmeProvider.getItems();
  }

  @override
  void initState() {
    _refreshJournals();

    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      print('vindooo');
      /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MyWidget()),
          (route) => route.isFirst);*/
    });

    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Insert a new journal to the database

  TextEditingController txtControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.green,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        offset: Offset(0, 0),
                                        blurRadius: 1,
                                        spreadRadius: 1)
                                  ]),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'How Name are you today Afters sa are from sa ?',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: 'Search', filled: true),
                          autofocus: true,
                          controller: txtControler,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              final int helloAlarmID = 0;
                              await AndroidAlarmManager.periodic(
                                  const Duration(minutes: 2),
                                  helloAlarmID,
                                  printHello,
                                  exact: true,
                                  wakeup: true);
                            },
                            child: Text('Alamar android plus period')),
                        ElevatedButton(
                            onPressed: () async {},
                            child: Text('create alarme normal')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Text('5'),
            ),
            Container(
              width: double.infinity,
              height: 400,
              color: Colors.white,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => Container(child: Text('ok')),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlarmeCriacaoPage()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
