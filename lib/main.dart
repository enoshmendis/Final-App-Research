import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:mlvapp/Authenticate/login.dart';
import 'package:mlvapp/Authenticate/splash_screen.dart';
import 'package:mlvapp/home.dart';
import 'package:mlvapp/provider/authentication_provider.dart';
import 'package:mlvapp/services/navigation_service.dart';
import 'package:mlvapp/welcome_page.dart';
import 'package:provider/provider.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // //await DatabaseService().deleteDatabase();
  // await DatabaseService().initDatabase();

  // runApp(const MyApp());

  runApp(SplashScreen(
    key: UniqueKey(),
    onInitializationComplete: () {
      runApp(MainApp());
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mental Health',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/welcome',
        routes: {
          '/welcome': (BuildContext _context) => WelcomePage(),
          '/login': (BuildContext _context) => LogIn(),
          '/home': (BuildContext _context) => Home(),
        },
      ),
    );
  }
  //   return MaterialApp(
  //     title: 'Mental Health',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: SplashScreen(), //GSETest(),
  //     initialRoute: '/auth',
  //     routes: {
  //       '/login': (BuildContext _context) => LogIn(),
  //       '/home': (BuildContext _context) => Home(),
  //     },
  //   )
  // }
}
