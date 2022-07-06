import 'package:flutter/material.dart';
import 'package:project2/constants/routes.dart';
import 'package:project2/services/auth/auth_exceptions.dart';
import 'package:project2/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          title: const Text('Login'),
        ),
        body: FutureBuilder(
            future: _calculation,
            builder: (context, snapshot) {
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
                            await AuthService.firebase()
                                .logIn(email: email, password: password);

                            final user = AuthService.firebase().currentUser;
                            if (user?.isEmailVerified ?? false) {
                              await Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                notesRoute,
                                (route) => false,
                              );
                            } else {
                              await Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      verifyEmailView, (route) => false);
                            }
                          } on UserNotFoundAuthException {
                            await showErrorDialog(context, 'User not found');
                          } on WrongPasswordAuthException {
                            await showErrorDialog(context, 'Wrong credentials');
                          } on GenericAuthException {
                            await showErrorDialog(
                                context, 'Authentication Error');
                          }
                        },
                        child: const Text('Login'),
                      ),
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute, (route) => false)
                        },
                        child: const Text('Please register'),
                      ),
                    ],
                  );

                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
