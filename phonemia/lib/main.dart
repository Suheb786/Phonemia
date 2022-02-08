import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phonemia/screens/delete_screen.dart';
import 'package:phonemia/screens/home_screen.dart';
import 'package:phonemia/screens/uploader.dart';
import 'package:phonemia/screens/wrapper.dart';
import 'package:phonemia/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';

// These are some changes
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: "Phonemia",
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: HomeScreen.routeName,
        routes: {
          Wrapper.routeName: (ctx) => Wrapper(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          LogInScreen.routeName: (ctx) => LogInScreen(),
          UploaderScreen.routeName: (ctx) => UploaderScreen(),
          DeleteScreen.routeName:(ctx)=>DeleteScreen(),
        },
      ),
    );
  }
}
