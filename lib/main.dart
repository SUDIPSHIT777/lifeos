import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lifeos/core/utils/errorpage.dart';
import 'package:lifeos/feature/ai_assistant/controller/deepsheekprovider.dart';
import 'package:lifeos/feature/dashboard/controller/dashprovider.dart';
import 'package:lifeos/feature/dashboard/controller/timerset.dart';
import 'package:lifeos/feature/dashboard/controller/weatherprovider.dart';
import 'package:lifeos/feature/splashscreen/splashprovider.dart';
import 'package:lifeos/feature/tasks/controller/allupdatefunction.dart';
import 'package:lifeos/feature/tasks/controller/taskprovider.dart';
import 'package:lifeos/login/googleauth/googleauth.dart';
import 'package:lifeos/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(child: ErrorPage());
  };
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Userprovider()),
        ChangeNotifierProvider(create: (context) => Taskprovider()),
        ChangeNotifierProvider(create: (context) => GoogleAuth()),
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => FocusTimerProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider(create: (context) => DateTimeProvider()),
        ChangeNotifierProvider(create: (context) => Deepsheekprovider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// Color(0xFF00c247)green
// Color(0xFFFF9800)red
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final Routes routes = Routes();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routes.router,
    );
  }
}
