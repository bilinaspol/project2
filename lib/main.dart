import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
//÷import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 1),
    () => 'Data Loaded',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: FutureBuilder(
            future: _calculation,
            builder: (context, snapshot) {
              Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              );

              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && user.emailVerified) {
                    print('Email verified!');
                  } else {
                    print('Email Not verified');
                  }
                  return Text('Done');

                default:
                  return const Text('Loading....');
              }
            }));
  }
}
