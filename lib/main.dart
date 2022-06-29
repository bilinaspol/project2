import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2/views/verify_email_view.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
//÷import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => NotesView(),
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
    },
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
                  print('hi, $user?.emailVerified');
                  if (user != null) {
                    if (user.emailVerified) {
                      return NotesView();
                      //return const Text('Email verified Done');
                    } else {
                      return const VerifyEmailView();
                    }
                  } else {
                    return const LoginView();
                  }

                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String _selectedMenuItem = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
              onSelected: (MenuAction item) {
                setState(() {
                  _selectedMenuItem = item.name;
                });
              },
              itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text('Logout'),
                    ),
                  ]),
        ],
      ),
      body: Text('Hello from Main UI'),
    );
  }
}
