import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isEmailSent = false;
  String authError = '';

  void updateAuthError(String val) => setState(() {
        authError = val;
      });

  void updateIsEmailSent(bool value) => setState(() {
        isEmailSent = value;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reset Password"),
        ),
        body: (Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 22),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: "Enter email to reset password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                      )),
                  Text(
                    authError,
                    style: const TextStyle(color: Colors.red),
                  ),
                  Text(isEmailSent
                      ? "An email has been sent to your inbox"
                      : ''),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: emailController.text);
                            updateIsEmailSent(true);
                          } on FirebaseAuthException catch (e) {
                            print('Failed with error code: ${e.code}');
                            print('error ${e.message}');
                            updateIsEmailSent(false);
                            updateAuthError(e.message ??
                                "Something went wrong, please try again");
                          }
                        }
                      },
                      child: const Text("Send Reset Password Email")),
                ])))));
  }
}
