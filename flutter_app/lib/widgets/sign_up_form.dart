import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordVerifyController = TextEditingController();

  String authError = '';

  void updateAuthError(String val) => setState(() {
        authError = val;
      });

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 22),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  )),
              TextFormField(
                controller: passwordVerifyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Verify Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a verification password';
                  }

                  if (passwordController.text
                          .compareTo(passwordVerifyController.text) !=
                      0) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              Text(
                authError,
                style: const TextStyle(color: Colors.red),
              ),
              ElevatedButton(
                  onPressed: () async {
                    updateAuthError("");
                    if (_formKey.currentState!.validate()) {

                      try {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                      } on FirebaseAuthException catch (e) {
                        print('Failed with error code: ${e.code}');
                        print(e.message);
                        updateAuthError(e.message ??
                            "Something went wrong, please try again");
                      }
                    }
                  },
                  child: const Text("Create Account")),
            ])));
  }
}
