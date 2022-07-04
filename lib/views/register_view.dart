import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

import '../constants/routes.dart';
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
                            final user = FirebaseAuth.instance.currentUser;
                            await user?.sendEmailVerification();
                            Navigator.of(context).pushNamed(verifyEmailView);
                            devtools.log(userCredential.toString());
                          } on FirebaseAuthException catch (e) {
                            devtools.log(e.toString());
                            if (e.code == 'email-already-in-use') {
                              await showErrorDialog(
                                  context, 'Email already in use');
                            } else if (e.code == 'weak-password') {
                              await showErrorDialog(context, 'Weak password');
                            } else if (e.code == 'invalid-email') {
                              await showErrorDialog(context, 'Invalid email');
                            } else {
                              await showErrorDialog(context, 'Error ${e.code}');
                            }
                          } catch (e) {
                            await showErrorDialog(context, e.toString());
                          }
                        },
                        child: const Text('Register'),
                      ),
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false)
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
