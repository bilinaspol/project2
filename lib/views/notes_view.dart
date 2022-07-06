import 'package:flutter/material.dart';
import 'package:project2/constants/routes.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import '../enums/menu_action.dart';

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
              onSelected: (MenuAction item) async {
                switch (item) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();

                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                    devtools.log('notes_view:34: ${shouldLogout.toString()}');
                    break;
                }

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

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Sign out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Log out')),
            ]);
      }).then((value) => value ?? false);
}
