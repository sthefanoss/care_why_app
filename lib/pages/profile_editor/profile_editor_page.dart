import 'dart:typed_data';

import 'package:care_why_app/pages/home/home_page.dart';
import 'package:care_why_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/image_picker.dart';
import '../../providers/colleges_providers.dart';
import '../../providers/lups_provider.dart';

class ProfileEditorPage extends StatefulWidget {
  const ProfileEditorPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditorPage> createState() => _ProfileEditorPageState();
}

class _ProfileEditorPageState extends State<ProfileEditorPage> {
  late final AuthProvider authProvider;
  final _nameDescription = TextEditingController();
  String? _currentImage;
  Uint8List? _imageData;
  bool _isLoading = false;

  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameDescription.text = authProvider.authUser?.profile?.nickname ?? '';
    _currentImage = authProvider.authUser?.profile?.imageUrl;
    super.initState();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameDescription,
                decoration: const InputDecoration(
                  label: Text('Apelido'),
                ),
              ),
              const SizedBox(height: 20),
              Text('Foto'),
              const SizedBox(height: 10),
              ImageSelector(
                onChanged: (imageData) => _imageData = imageData,
                currentSelectedImage: _currentImage,
              ),
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                fit: StackFit.passthrough,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: Text('Salvar'),
                  ),
                  if (_isLoading)
                    Positioned.fill(
                        child: Center(child: CircularProgressIndicator())),
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
    setState(() => _isLoading = true);
    try {
      await authProvider.updateProfile(
        nickname: _nameDescription.text,
        image: _imageData,
      );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (c) => HomePage()));
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
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop, child: Text('Ok'))
            ],
          );
        });
  }
}
