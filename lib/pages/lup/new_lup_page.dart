import 'dart:developer';
import 'dart:typed_data';

import 'package:care_why_app/components/image_picker.dart';
import 'package:care_why_app/providers/auth_provider.dart';
import 'package:care_why_app/providers/colleges_providers.dart';
import 'package:care_why_app/providers/lups_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/lup.dart';
import '../../models/user.dart';
import '../../services/http_client.dart';
import 'components/lup_participant_chip.dart';

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
  late final AuthProvider _authProvider;
  bool _isLoading = false;
  Uint8List? _imageData;
  final _participantIds = <int>{};

  @override
  void initState() {
    _collegesProvider = Provider.of<CollegesProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _collegesProvider.getCollegesFromApi();
    super.initState();
  }

  Future<void> postLUP() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<LupsProvider>(context, listen: false).createLup(
        title: _titleController.text,
        description: _descriptionController.text,
        image: _imageData!,
        collaboratorIds: _participantIds.toList(),
      );
    } on DioError catch (e) {
      setState(() => _isLoading = false);
      print(e);
      rethrow;
    } catch (_) {
      print(_);
      setState(() => _isLoading = false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Registrar LUP'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            // _isLoading || _imageData == null ? null :
            onPressed: _onSave,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Divider(height: 1, thickness: 1),
                  Text('Dados'),
                  Divider(height: 1, thickness: 1),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      label: Text('Título'),
                    ),
                    validator: (text) {
                      if (text?.isEmpty ?? true) {
                        return 'Campo obrigatório';
                      }
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      label: Text(
                        'Descrição',
                      ),
                    ),
                    validator: (text) {
                      if (text?.isEmpty ?? true) {
                        return 'Campo obrigatório';
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Divider(height: 1, thickness: 1),
                  Text('Foto'),
                  Divider(height: 1, thickness: 1),
                  const SizedBox(height: 10),
                  ImageSelector(onChanged: _onImageChanged),
                  const SizedBox(height: 10),
                  Divider(height: 1, thickness: 1),
                  Text('Participantes'),
                  Divider(height: 1, thickness: 1),
                  const SizedBox(height: 10),
                  Text('Selecione quem lhe ajudou na realização da LUP clicando abaixo'),
                  const SizedBox(height: 10),
                  Consumer<CollegesProvider>(
                    builder: (_, p, __) => Wrap(
                      children: p.colleges
                          .where((element) =>
                              element.profile != null &&
                              element.id != _authProvider.authUser!.id)
                          .map((e) => LupParticipantChip(
                                participant: e,
                                selected: _participantIds.contains(e.id),
                                onTap: (e) {
                                  if (_participantIds.contains(e.id)) {
                                    _participantIds.remove(e.id);
                                  } else {
                                    _participantIds.add(e.id);
                                  }
                                  setState(() {});
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ],
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
    await postLUP();
    Navigator.of(context).pop();
  }

  void _onImageChanged(Uint8List? imageData) {
    _imageData = imageData;
  }
}
