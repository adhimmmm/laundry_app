import 'package:flutter/material.dart';


import 'package:loundry_app/app/modules/auth/views/register_view.dart';
import 'package:loundry_app/app/modules/auth/views/signin_view.dart';


class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isLogin
            ? SigninView(
                key: const ValueKey('signin'),
                onRegisterTap: () {
                  setState(() => isLogin = false);
                },
              )
            : RegisterView(
                key: const ValueKey('register'),
                onLoginTap: () {
                  setState(() => isLogin = true);
                },
              ),
      ),
    );
  }
}
