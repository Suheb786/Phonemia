import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phonemia/constants/colors.dart';
import 'package:phonemia/screens/login_screen.dart';
import 'package:phonemia/screens/uploader.dart';
import 'package:phonemia/services/auth_service.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  static const routeName = "wrapper";
  Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authState.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? LogInScreen() : UploaderScreen();
        } else {
          return Scaffold(
              backgroundColor: bg1,
              body: Center(
                child: CircularProgressIndicator(),
              ));
        }
      },
    );
  }
}
