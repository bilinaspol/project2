import 'package:flutter/material.dart';
import 'package:project2/constants/routes.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/views/notes/new_note_view.dart';
import 'package:project2/views/notes/notes_view.dart';
import 'package:project2/views/verify_email_view.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'dart:developer' as devtools show log;
//÷import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // initialRoute: '/',
    home: const HomePage(),
    routes: {
      notesRoute: (context) => NotesView(),
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailView: (context) => const VerifyEmailView(),
      newNoteRoute: (context) => const NewNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // final Future<String> _calculation = Future<String>.delayed(
  //   const Duration(seconds: 1),
  //   () => 'Data Loaded',
  // );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              devtools.log('main:47: --- ${user?.isEmailVerified}');
              if (user != null) {
                if (user.isEmailVerified) {
                  return NotesView();
                  //return const Text('Email verified Done');
                } else {
                  return const VerifyEmailView(); //<--- lATER!
                }
              } else {
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
