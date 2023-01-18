import 'package:care_why_app/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
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
  bool _isPasswordObscured = true;
  bool _isConfirmationObscured = true;

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
        title: Text( _isSignUp ? 'Cadastro' : 'Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              SvgPicture.asset(
                'assets/svgs/logo.svg',
              ),
              SizedBox(height: 50),
              Text(
                'Bem-vindo!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 50),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(label: Text('Nome de usuário'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                ),
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
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  label: Text('Senha'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                  suffixIcon: IconButton(
                    icon: _isPasswordObscured ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                textInputAction: _isSignUp ? TextInputAction.next : TextInputAction.done,
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
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    label: Text('Confirmar Senha'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                    suffixIcon: IconButton(
                      icon: _isConfirmationObscured ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isConfirmationObscured = !_isConfirmationObscured;
                        });
                      },
                    ),
                  ),
                  controller: _confirmPasswordController,
                  obscureText: _isConfirmationObscured,
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
              ] ,
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                    child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _isSignUp
                                ? _submitSignup
                                : _submitLogin,
                        child: Text(_isSignUp ? 'Cadastrar' : 'Entrar'),

              ),
                  ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                    onPressed: () {
                      if (_isLoading) return;
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
                    child: Text(_isSignUp ? 'Login' : 'Cadastro')),
              )
            ],
          ),
        ),
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

      if (authProvider.authUser!.nickname == null) {
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
      await Future.delayed(Duration(milliseconds: 500));
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
      await Future.delayed(Duration(milliseconds: 500));
      setState(() => _isLoading = false);
      rethrow;
    }
  }
}
