import 'package:care_why_app/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/http_client.dart';
import '../profile_editor/profile_editor_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Care why app'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50),
                  Text('Seja bem vindo ao Care why app'),
                  SizedBox(height: 50),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Usuário')),
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    validator: (s) {
                      if (s?.isEmpty ?? true) {
                        return 'Campo obrigatório';
                      }
                      if (s!.length < 4) {
                        return 'Deve ter pelo menos 4 caracteres';
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Senha'),
                    ),
                    controller: _passwordController,
                    textInputAction:
                        _isSignUp ? TextInputAction.next : TextInputAction.done,
                    validator: (s) {
                      if (s?.isEmpty ?? true) {
                        return 'Campo obrigatório';
                      }
                      if (s!.length < 4) {
                        return 'Deve ter pelo menos 4 caracteres';
                      }
                    },
                  ),
                  if (_isSignUp) ...[
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Confirmar Senha'),
                      ),
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      validator: (s) {
                        if (s?.isEmpty ?? true) {
                          return 'Campo obrigatório';
                        }
                        if (s!.length < 4) {
                          return 'Deve ter pelo menos 4 caracteres';
                        }
                        if (s != _passwordController.text) {
                          return 'As senhas não conferem';
                        }
                      },
                    ),
                  ] else
                    SizedBox(height: 60),
                  SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _isSignUp
                              ? _submitSignup
                              : _submitLogin,
                      child: Text(_isSignUp ? 'Continuar' : 'Entrar')),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                        });
                      },
                      child: Text(_isSignUp ? 'Voltar' : 'Cadastrar'))
                ],
              ),
            ),
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _submitLogin() async {
    _formKey.currentState!.reassemble();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (authProvider.authUser!.profile == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (c) => ProfileEditorPage(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (c) => HomePage(),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      rethrow;
    }
  }

  void _submitSignup() async {
    _formKey.currentState!.reassemble();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signup(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (c) => ProfileEditorPage(),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      rethrow;
    }
  }
}
