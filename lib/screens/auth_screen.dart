// screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_service.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isDoctor = false;
  String _email = '';
  String _password = '';
  String _name = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (_isLogin) {
        await authService.signIn(_email, _password);
      } else {
        await authService.signUp(_email, _password, _name, _isDoctor);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!_isLogin) ...[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
                    onSaved: (value) => _name = value!,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isDoctor,
                        onChanged: (value) {
                          setState(() {
                            _isDoctor = value!;
                          });
                        },
                      ),
                      Text('I am a doctor'),
                    ],
                  ),
                ],
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter an email' : null,
                  onSaved: (value) => _email = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter a password' : null,
                  onSaved: (value) => _password = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'Login' : 'Register'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? 'Create new account'
                      : 'I already have an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}