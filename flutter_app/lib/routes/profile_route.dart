import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileRoute extends StatefulWidget {
  const ProfileRoute({Key? key}) : super(key: key);

  @override
  State<ProfileRoute> createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {}
          User? user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text("User Profile"),
            ),
            body: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Column(
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(user?.email ?? ""),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      child: const Text("Logout"),
                    )
                  ],
                ))),
          );
        });
  }
}
