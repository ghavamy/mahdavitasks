import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mahdavitasks/AniamtionSplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'DatesWindow/note_store.dart';

// New imports for notifications
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

// Create a single notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


//for giving permission in the app
Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

//initializing the notification settings
Future<void> initializeNotifications() async {
  // Init local notifications
  const AndroidInitializationSettings initSettingsAndroid =
      AndroidInitializationSettings('ic_notification');

  const InitializationSettings initSettings =
      InitializationSettings(android: initSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}


void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  // Load your NotesStore
  final notesStore = NotesStore();
  await notesStore.loadData();

  runApp(
    ChangeNotifierProvider.value(
      value: notesStore,
      child: const MyApp(),
    ),
  );

  //initialize notifications
  Future.microtask(initializeNotifications);

  // Init WorkManager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: !kReleaseMode,//automatically toggle for build or debug
  );

  await Workmanager().cancelAll();
  // Schedule periodic task every 15 minutes
  await Workmanager().registerPeriodicTask(
    "checkTasksUnique",
    "checkTasks",
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(minutes: 1),
  );

  //running the permission first
  await requestNotificationPermission();
}

// Background task dispatcher
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Ensure Flutter engine is ready in the background isolate
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize notifications in the background isolate
      await initializeNotifications();

      debugPrint("Workmanager task triggered in background: $task");
      debugPrint("Input data: ${inputData?.toString() ?? 'none'}");

      String message;

      // If a message is passed via inputData, use it
      if (inputData != null && inputData['message'] != null) {
        message = inputData['message']!;
      } else if (task == "checkTasks") {
        // Otherwise, build the message from NotesStore
        final store = NotesStore();
        await store.loadData();

        final today = Jalali.now();
        final todayTasks = store.entriesOn(today.year, today.month, today.day);
        final hasTasks = todayTasks.isNotEmpty;

        message = hasTasks
            ? 'حواست به انجام اعمالی که ثبت کردی باشه.'
            : 'برای خشنودی امام زمان (عج) عملی رو ثبت کن و انجام بده.';
      }else{
        message = 'این یک یادآوری عمومی است.';
      }

      debugPrint(">>> Final message to show : $message");
      await showNotification(message);

      return Future.value(true); // ✅ success
    } catch (e, st) {
      debugPrint("Error in background task: $e\n$st");
      return Future.value(false); // ❌ failure
    }
  });
}


// Show a local notification
Future<void> showNotification(String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'tasks_channel',
    'Tasks Notifications',
    channelDescription: 'Notifications about your daily tasks',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'یادآوری اعمال',
    body,
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AnimatedSplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}