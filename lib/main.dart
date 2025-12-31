import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_eurotech/screens/Login/login.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:mahavar_eurotech/provider/login_sliding_up.dart';
import 'package:mahavar_eurotech/provider/panel_provider.dart';
import 'package:mahavar_eurotech/screens/Getting%20started/getting_started.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mahavar_eurotech/provider/mobileno_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("b737adcf-38bf-4613-a5ef-407d6210cae1");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  playerId = OneSignal.User.pushSubscription.id;
  print("Player id : $playerId");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    getPref();
    super.initState();
  }

  bool? getStartedSeen;
  bool? login;

  void getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getStartedSeen = prefs.getBool("getStartedSeen");
    login = prefs.getBool("loginInned");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SlidingUpPanelProvider()),
        ChangeNotifierProvider(create: (context) => PanelProvider()),
        ChangeNotifierProvider(create: (_) => MobileNo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mahavar Eurotech',
        theme: ThemeData(
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: color2),
          useMaterial3: true,
        ),
        home: getStartedSeen != null
            ? login != null
                ? const BottomNavBar()
                : const LoginPage()
            : const GettingStarted(),
      ),
    );
  }
}
