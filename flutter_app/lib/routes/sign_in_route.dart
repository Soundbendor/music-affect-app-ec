import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/forget_password_form.dart';
import 'package:flutter_app/widgets/sign_in_form.dart';
import 'package:flutter_app/widgets/sign_up_form.dart';

class SignInRoute extends StatefulWidget {
  const SignInRoute({Key? key}) : super(key: key);

  @override
  State<SignInRoute> createState() => _SignInRouteState();
}

class _SignInRouteState extends State<SignInRoute> {
  bool isLogin = true;

  void setIsLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Music Affect Data")),
        body: Column(children: [
          isLogin ? const SignInForm() : const SignUpForm(),
          MaterialButton(
            onPressed: () => setIsLogin(),
            child: Text(
              isLogin ? "Create Account" : "Sign In",
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          isLogin ? MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgetPasswordForm()),
              );
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.blue),
            ),
          ) : const Text("")
        ]));
  }
}
