import 'package:care_why_app/providers/exchanges_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/user.dart';
import '../providers/colleges_providers.dart';

class AddExchangePopup extends StatefulWidget {
  const AddExchangePopup({
    required this.user,
    required this.onComplete,
    Key? key,
  }) : super(key: key);

  final User user;

  final VoidCallback onComplete;

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
  State<AddExchangePopup> createState() => _AddExchangePopupState();
}

class _AddExchangePopupState extends State<AddExchangePopup> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  late final CollegesProvider collegesProvider;
  late final ExchangesProvider exchangesProvider;
  double _coins = 0;

  @override
  void initState() {
    collegesProvider = Provider.of<CollegesProvider>(context, listen: false);
    exchangesProvider = Provider.of<ExchangesProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: SimpleDialog(
        title: Text('Solicitar troca'),
        contentPadding: EdgeInsets.all(20),
        children: [
          InputDecorator(
            decoration: InputDecoration(
              label: Text('Destinatário'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text('@${widget.user.username}'),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                label: Text('Descrição'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
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
          Text('Custo \$ ${_coins.toInt().toString()}'),
          Slider(
            onChanged: (v) => setState(() {
              _coins = v;
            }),
            min: 0,
            max: widget.user.coins.toDouble(),
            divisions: widget.user.coins,
            value: _coins,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isLoading || _coins == 0
                    ? null
                    : () async {
                        _formKey.currentState!.reassemble();
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() => _isLoading = true);
                        try {
                          await exchangesProvider.makeExchange(
                            reason: _usernameController.text.trim(),
                            username: widget.user.username,
                            coins: _coins.toInt(),
                          );
                          await exchangesProvider.getExchangesFromApi();
                          Navigator.of(context).pop();
                          widget.onComplete();
                        } finally {
                          if (mounted)
                            setState(() {
                              _isLoading = false;
                            });
                        }
                      },
                child: Text('Confirmar'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        Navigator.of(context).pop();
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Constants.colors.background),
                child: Text('Cancelar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
