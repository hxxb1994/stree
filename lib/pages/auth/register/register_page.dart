import 'package:base_provider/base_provider.dart';
import 'package:flutter/material.dart';

import 'register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseView<RegisterPage, RegisterController> {
  @override
  Widget buildContent(BuildContext context, RegisterController controller) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Page')),
      body: Center(child: const Text('No user data')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
