import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/routes/personal_data_route.dart';
import 'package:flutter_app/routes/profile_route.dart';
import 'package:flutter_app/routes/sign_in_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tabs/home_tab.dart';
import '../tabs/tutorial_tab.dart';

class AuthGate extends StatefulWidget {
  final SharedPreferences preferences;
  const AuthGate({Key? key,  required this.preferences}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInRoute();
        }

        if (widget.preferences.getBool(snapshot.data?.uid ?? "") == null) {
          return PersonalDataRoute(
            preferences: widget.preferences,
            uuid: snapshot.data?.uid ?? '',
            updateState: () => setState(() {}),
          );
        }

        return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Music Affect Data'),
                  bottom: const TabBar(tabs: [
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.question_mark)),
                  ]),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      tooltip: 'Open user profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileRoute()),
                        );
                      },
                    ),
                  ],
                ),
                body: const Padding(
                  padding: EdgeInsets.all(10),
                  child: TabBarView(children: [HomeTab(), TutorialTab()]),
                )));
      },
    );
  }
}
