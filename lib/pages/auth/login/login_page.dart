import 'package:base_provider/base_provider.dart';
import 'package:flutter/material.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseView<LoginPage, LoginController> {
  String username = '';
  String password = '';

  @override
  Widget buildContent(BuildContext context, LoginController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Username'),
            onChanged: (value) {
              username = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onLoginPressed,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _onLoginPressed() {
    controller.login(username, password);
  }
}
