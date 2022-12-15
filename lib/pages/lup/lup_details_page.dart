import 'package:care_why_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/lup.dart';
import '../../models/user.dart';
import '../../utils/utils.dart';
import '../home/components/colleagues_tab.dart';

class LupDetailsPage extends StatelessWidget {
  const LupDetailsPage({required this.lup, required this.author, Key? key}) : super(key: key);

  final Lup lup;

  final User author;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LUP'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          InputDecorator(
            decoration: const InputDecoration(
              label: Text('Título'),
            ),
            child: Text(lup.title),
          ),
          const SizedBox(height: 20),
          InputDecorator(
            decoration: const InputDecoration(
              label: Text('Autor'),
            ),
            child: Consumer<AuthProvider>(
              builder: (c, auth, _) => UserTile(
                user: author,
                authUser: auth.authUser!,
                showActions: false,
              ),
            ),
          ),
          const SizedBox(height: 20),
          InputDecorator(
            decoration: const InputDecoration(
              label: Text('Data de criação'),
            ),
            child: Text(Utils.formatDateTime(lup.createdAt, format: 'HH:mm dd/MM/yyyy')),
          ),
          const SizedBox(height: 20),
          InputDecorator(
            decoration: const InputDecoration(
              label: Text('Descrição'),
            ),
            child: Text(lup.description),
          ),
          const SizedBox(height: 20),
          InputDecorator(
            decoration: const InputDecoration(
              label: Text('Foto'),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                lup.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          child: Text('Voltar'),
          onPressed: Navigator.of(context).pop,
        ),
      ),
    );
  }
}
