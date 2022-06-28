import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Verify your email'),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text('press verify'),
        ),
      ],
    );
  }
}
