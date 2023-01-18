import 'dart:typed_data';

import 'package:care_why_app/components/image_picker.dart';
import 'package:care_why_app/providers/auth_provider.dart';
import 'package:care_why_app/providers/colleges_providers.dart';
import 'package:care_why_app/providers/lups_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class LUPPage extends StatefulWidget {
  const LUPPage({super.key});

  @override
  State<LUPPage> createState() => _LUPPageState();
}

class _LUPPageState extends State<LUPPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final CollegesProvider _collegesProvider;
  bool _isLoading = false;
  Uint8List? _imageData;
  late String _lupDate;

  @override
  void initState() {
    _collegesProvider = Provider.of<CollegesProvider>(context, listen: false);
    _collegesProvider.getCollegesFromApi();
    _lupDate =  Utils.formatDateTime(
      DateTime.now(),
      format: "dd/MM/yyyy",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) {
          return false;
        }

        final result = await showDialog<bool>(
          context: context,
          builder: (c) => SimpleDialog(
            title: Text('Tem certeza que deseja voltar?'),
            contentPadding: EdgeInsets.all(10),
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Seu progresso será perdido.'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Não')),
                  TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Sim')),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
        return result ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Criar lição'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        label: Text('Nome da lição'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (text) {
                        if (text?.isEmpty ?? true) {
                          return 'Criador';
                        }
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              label: Text('Criador'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text('@' + (authProvider.authUser?.username ?? '')),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              label: Text('Data'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(_lupDate),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        label: Text('Descrição'),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (text) {
                        if (text?.isEmpty ?? true) {
                          return 'Campo obrigatório';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ImageSelector(onChanged: _onImageChanged),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height:60,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Criar'),
                onPressed: _isLoading ? null : _onSave,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_imageData == null) {
      showDialog(
          context: context,
          builder: (c) => SimpleDialog(
              title: Text('É preciso carregar uma foto\n da lição de ponto!'),
              children: [TextButton(onPressed: Navigator.of(context).pop, child: Text('Ok'))]));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Provider.of<LupsProvider>(context, listen: false).createLup(
        title: _titleController.text,
        description: _descriptionController.text,
        image: _imageData!,
        // collaboratorIds: _participantIds.toList(),
      );
      Navigator.of(context).pop();
    } on DioError catch (e) {
      print(e);
      await Future.delayed(Duration(milliseconds: 500));
      showDialog(
          context: context,
          builder: (c) => SimpleDialog(
              title: Text('Ocorreu um erro inesperado!\nPor favor, contate seu(sua) líder e tente mais tarde.'),
              children: [TextButton(onPressed: Navigator.of(context).pop, child: Text('Ok'))]));
      setState(() => _isLoading = false);
      rethrow;
    } catch (e) {
      print(e);
      await Future.delayed(Duration(milliseconds: 500));
      setState(() => _isLoading = false);
      rethrow;
    }
  }

  void _onImageChanged(Uint8List? imageData) {
    _imageData = imageData;
  }
}
