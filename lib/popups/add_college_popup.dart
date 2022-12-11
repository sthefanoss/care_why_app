import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/colleges_providers.dart';

class AddCollegePopup extends StatefulWidget {
  const AddCollegePopup({Key? key}) : super(key: key);

  Future<void> show(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => this,
      barrierDismissible: false,
    );
  }

  @override
  State<AddCollegePopup> createState() => _AddCollegePopupState();
}

class _AddCollegePopupState extends State<AddCollegePopup> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  late final CollegesProvider collegesProvider;

  @override
  void initState() {
    collegesProvider = Provider.of<CollegesProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: SimpleDialog(
        title: Text('Cadastrar colega'),
        contentPadding: EdgeInsets.all(20),
        children: [
          Text('Entre o nome do usuário que deseja cadastrar.'),
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(label: Text('Username')),
              controller: _usernameController,
              validator: (s) {
                if (s?.trim().isEmpty ?? true) {
                  return 'Campo obrigatório';
                }
                if (s!.trim().length < 4) {
                  return 'Deve ter pelo menos 4 caracteres';
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        Navigator.of(context).pop();
                      },
                child: Text('Cancelar'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        _formKey.currentState!.reassemble();
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() => _isLoading = true);
                        try {
                          await collegesProvider.makeUser(
                              username: _usernameController.text.trim());
                          await collegesProvider.getCollegesFromApi();
                          Navigator.of(context).pop();
                        } finally {
                          if (mounted)
                            setState(() {
                              _isLoading = false;
                            });
                        }
                      },
                child: Text('Enviar'),
              )
            ],
          )
        ],
      ),
    );
  }
}
