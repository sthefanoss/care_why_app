import 'dart:developer';
import 'dart:typed_data';

import 'package:care_why_app/components/image_picker.dart';
import 'package:care_why_app/providers/auth_provider.dart';
import 'package:care_why_app/providers/colleges_providers.dart';
import 'package:care_why_app/providers/lups_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lup.dart';
import '../../utils/utils.dart';

class LUPPage extends StatefulWidget {
  const LUPPage({super.key});

  @override
  State<LUPPage> createState() => _LUPPageState();
}

class _LUPPageState extends State<LUPPage> {
  final _titleController = TextEditingController();
  late final CollegesProvider _collegesProvider;
  bool _isLoading = false;
  Uint8List? _imageData;
  late String _lupDate;
  int? selectedType;
  String? nameError;
  String? categoryError;
  String? imageError;

  @override
  void initState() {
    _collegesProvider = Provider.of<CollegesProvider>(context, listen: false);
    _collegesProvider.getCollegesFromApi();
    _lupDate = Utils.formatDateTime(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      label: Text('Nome da lição'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorText: nameError,
                    ),
                    textInputAction: TextInputAction.next,
                    onTap: () => setState(() => nameError = null),
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
                  InputDecorator(
                    decoration: InputDecoration(
                      label: Text('Categoria'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorText: categoryError,
                    ),
                    child: Wrap(
                      children: lupTypes.entries.map<Widget>((e) {
                        void onSelect([int? v]) {
                          setState(() {
                            selectedType = e.key;
                            categoryError = null;
                          });
                        }

                        return InkWell(
                          onTap: onSelect,
                          splashColor: Colors.transparent,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<int?>(
                                value: e.key,
                                groupValue: selectedType,
                                onChanged: onSelect,
                              ),
                              Text(
                                e.value,
                                style: TextStyle(
                                  color: e.key == selectedType ? Colors.blue : null,
                                  fontSize: 10,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ImageSelector(
                    onChanged: _onImageChanged,
                    errorText: imageError,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
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
    nameError = _titleController.text.isEmpty ? "Campo obrigatório" : null;
    imageError = _imageData == null ? "Campo obrigatório" : null;
    categoryError = selectedType == null ? "Campo obrigatório" : null;
    setState(() {});
    if (nameError != null || imageError != null || categoryError != null) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Provider.of<LupsProvider>(context, listen: false).createLup(
        title: _titleController.text,
        typeId: selectedType!,
        image: _imageData!,
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
    imageError = null;
    _imageData = imageData;
    setState(() {});
  }
}
