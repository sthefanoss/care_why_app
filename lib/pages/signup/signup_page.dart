import 'dart:typed_data';

import 'package:care_why_app/pages/home/home_page.dart';
import 'package:care_why_app/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:care_why_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../components/image_picker.dart';
import '../../providers/colleges_providers.dart';
import '../../providers/lups_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameDescription = TextEditingController();
  Uint8List? _imageData;
  bool _isLoading = false;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Cadastro')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameDescription,
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
              ),
              const SizedBox(height: 20),
              Text('Avatar'),
              const SizedBox(height: 10),
              Text('Foto'),
              ImageSelector(onChanged: (imageData) => _imageData = imageData),
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                fit: StackFit.passthrough,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: Text('Cadastrar'),
                  ),
                  if (_isLoading) Positioned.fill(child: Center(child: CircularProgressIndicator())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_nameDescription.text.isEmpty) {
      showError('Por favor, digite seu nome ou apelido para ser usado no'
          'aplicativo ');
      return;
    }
    if (_nameDescription.text.length > 30) {
      showError('Por favor, utilize um nome com menos de 30 caracteres.');
      return;
    }
    if (_imageData == null) {
      showError('Por favor, selecione uma foto de perfil.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signUp(
        name: _nameDescription.text,
        image: _imageData!,
      );
      await Future.wait([
        Provider.of<CollegesProvider>(context, listen: false).getCollegesFromApi(),
        Provider.of<LupsProvider>(context, listen: false).getLupsFromApi(),
      ]);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c) => HomePage()));
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }
  }

  void showError(String message) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text(message),
            actions: [TextButton(onPressed: Navigator.of(context).pop, child: Text('Ok'))],
          );
        });
  }
}
