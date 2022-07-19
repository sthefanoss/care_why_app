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
  Map<User, bool> _otherParticipants = {};
  bool _init = false;
  bool _isLoading = false;
  Uint8List? _imageData;

  @override
  void didChangeDependencies() {
    if (!_init) {
      Provider.of<CollegesProvider>(context, listen: false).colleges.forEach((college) {
        _otherParticipants[college] = false;
      });

      _init = true;
    }
    super.didChangeDependencies();
  }

  Future<void> postLUP() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<LupsProvider>(context, listen: false).createLup(
          title: _titleController.text,
          description: _descriptionController.text,
          image: _imageData!,
          collaboratorIds: _otherParticipants.entries.where((element) => element.value).map((e) => e.key.id).toList());
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
                  Text('Foto'),
                  ImageSelector(onChanged: _onImageChanged),
                  const SizedBox(height: 10),
                  Divider(height: 1, thickness: 1),
                  Text('Participantes'),
                  Divider(height: 1, thickness: 1),
                  Text('Autor:'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LupParticipantChip(
                      participant: authProvider.authUser!,
                      isAuthor: true,
                    ),
                  ),
                  Text('Participantes:'),
                  Wrap(
                    children: _otherParticipants.entries
                        .where((element) => element.value)
                        .map((e) => LupParticipantChip(participant: e.key))
                        .toList(),
                  ),
                  TextButton(
                    child: Text('Adicionar'),
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (a, b, c) => ParticipantsPopup(
                          participants: _otherParticipants,
                          onChanged: (v) {
                            setState(() {
                              _otherParticipants[v.key] = v.value;
                            });
                          },
                        ),
                      );
                    },
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

class ParticipantsPopup extends StatefulWidget {
  const ParticipantsPopup({required this.participants, required this.onChanged, Key? key}) : super(key: key);

  final Map<User, bool> participants;

  final ValueChanged<MapEntry<User, bool>> onChanged;

  @override
  State<ParticipantsPopup> createState() => _ParticipantsPopupState();
}

class _ParticipantsPopupState extends State<ParticipantsPopup> {
  @override
  Widget build(BuildContext context) {
    final colleges = widget.participants.entries.toList();

    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text('Ajudantas da LUP'),
      content: Container(
        width: 200,
        constraints: BoxConstraints(maxHeight: size.height * 0.4),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: colleges.length,
              itemBuilder: (c, i) {
                final user = colleges[i].key;
                final selected = colleges[i].value;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                  ),
                  title: Text(user.name),
                  trailing: Checkbox(
                    value: selected,
                    onChanged: (v) => setState(() {
                      widget.onChanged(MapEntry(user, v ?? false));
                    }),
                  ),
                );
              },
            )),
            TextButton(onPressed: Navigator.of(context).pop, child: Text('Ok'))
          ],
        ),
      ),
    );
  }
}
