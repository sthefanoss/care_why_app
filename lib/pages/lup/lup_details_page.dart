import 'package:flutter/material.dart';

import '../../models/lup.dart';
import 'components/lup_participant_chip.dart';

class LupDetailsPage extends StatelessWidget {
  const LupDetailsPage({required this.lup, Key? key}) : super(key: key);

  final LUP lup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LUP'),
      ),
      body: ListView(
        children: [
          Divider(height: 1, thickness: 1),
          Text('Dados'),
          InputDecorator(
            decoration: const InputDecoration(
              label: Text('Título'),
            ),
            child: Text(lup.title),
          ),
          Divider(height: 1, thickness: 1),
          const SizedBox(height: 20),
          InputDecorator(
            decoration: const InputDecoration(
              label: Text('Descrição'),
            ),
            child: Text(lup.description),
          ),
          Text('Foto'),
          Image.network(
            lup.imageUrl,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Divider(height: 1, thickness: 1),
          Text('Participantes'),
          Divider(height: 1, thickness: 1),
          Text('Autor:'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LupParticipantChip(
              participant: lup.author,
              isAuthor: true,
            ),
          ),
          Text('Participantes:'),
          Wrap(
            children: lup.collaborators.map((e) => LupParticipantChip(participant: e)).toList(),
          ),
        ],
      ),
    );
  }
}
