import 'package:care_why_app/providers/exchanges_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/colleges_providers.dart';

class AddExchangePopup extends StatefulWidget {
  const AddExchangePopup({Key? key}) : super(key: key);

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
  User? _selectedUser;
  double _coins = 0;

  @override
  void initState() {
    collegesProvider = Provider.of<CollegesProvider>(context, listen: false);
    exchangesProvider = Provider.of<ExchangesProvider>(context, listen: false);
    collegesProvider.getCollegesFromApi();
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
        title: Text('Cadastrar troca'),
        contentPadding: EdgeInsets.all(20),
        children: [
          Text('Entre a troca, a quantidade gasta e o colega que trocou.'),
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(label: Text('Troca')),
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
          Text('Moedas gastas: ${_coins.toInt()}'),
          Slider(
            onChanged: (v) => setState(() {
              _coins = v;
            }),
            min: 0,
            max: _selectedUser?.coins.toDouble() ?? 0,
            divisions: _selectedUser?.coins ?? null,
            value: _coins,
          ),
          SizedBox(height: 20),
          Text('Colega'),
          SizedBox(
            height: size.height * 0.2,
            width: size.width * .5,
            child: Consumer<CollegesProvider>(
              builder: (_, colleges, __) {
                final collegesWithCoins = colleges.colleges
                    .where((c) =>
                        c.canMakeLups && c.nickname != null && c.coins > 0)
                    .toList();

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: collegesWithCoins.length,
                  itemBuilder: (c, i) => Container(
                    color: i % 2 == 0 ? Colors.black.withOpacity(0.035) : null,
                    child: ListTile(
                      title: Text(
                          '${collegesWithCoins[i].nickname} (\$${collegesWithCoins[i].coins})'),
                      selected: collegesWithCoins[i] == _selectedUser,
                      onTap: () => setState(() {
                        _selectedUser = collegesWithCoins[i];
                        _coins = 0;
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
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
                onPressed: _isLoading || _coins == 0 || _selectedUser == null
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
                            username: _selectedUser!.username,
                            coins: _coins.toInt(),
                          );
                          await exchangesProvider.getExchangesFromApi();
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
