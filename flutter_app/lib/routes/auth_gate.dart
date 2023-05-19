import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/routes/personal_data_route.dart';
import 'package:flutter_app/routes/profile_route.dart';
import 'package:flutter_app/routes/sign_in_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tabs/home_tab.dart';
import '../tabs/tutorial_tab.dart';

class AuthGate extends StatelessWidget {
  final SharedPreferences preferences;
  const AuthGate({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInRoute();
        }

        if (preferences.getBool(snapshot.data?.uid ?? "") == null) {
          return PersonalDataRoute(
            preferences: preferences,
            uuid: snapshot.data?.uid ?? '',
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
