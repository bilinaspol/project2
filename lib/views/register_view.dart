import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  var credentials = 'not yet';
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 1),
    () => 'Data Loaded',
  );
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController(); // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: FutureBuilder(
            future: _calculation,
            builder: (context, snapshot) {
              Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              );

              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration:
                            const InputDecoration(hintText: 'Enter your email'),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                            hintText: 'Enter your password'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            print(userCredential);
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            if (e.code == 'email-already-in-use') {
                              print('Email already in use');
                            } else if (e.code == 'weak-password') {
                              print('Weak password');
                            } else if (e.code == 'invalid-email') {
                              print('Invalid email');
                            }
                          }
                        },
                        child: const Text('Register'),
                      ),
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => true)
                        },
                        child: const Text('Registered? Please, login'),
                      ),
                    ],
                  );

                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
