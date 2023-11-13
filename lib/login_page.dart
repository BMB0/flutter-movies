import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
      );
    } catch (e) {
      debugPrint('LocalAuth Error: $e');
    }
    if (authenticated) {
      Navigator.of(context).pushNamed('/movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pushNamed('/movies');
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _authenticateWithBiometrics(context),
                  child: const Text('Login with fingerprint'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
