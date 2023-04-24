import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
                "Sign In",
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
              TextFormField(
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
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                      } on FirebaseAuthException catch (e) {
                        print('Failed with error code: ${e.code}');
                        print('error ${e.message}');
                        updateAuthError(e.message ??
                            "Something went wrong, please try again");
                      }
                    }
                  },
                  child: const Text("Sign In")),
            ])));
  }
}
