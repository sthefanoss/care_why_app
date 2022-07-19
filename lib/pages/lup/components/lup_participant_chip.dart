import 'package:flutter/material.dart';

import '../../../models/user.dart';

class LupParticipantChip extends StatelessWidget {
  const LupParticipantChip({
    required this.participant,
    this.isAuthor = false,
    Key? key,
  }) : super(key: key);

  final User participant;

  final bool isAuthor;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(participant.imageUrl),
          ),
          Flexible(child: Text(participant.name))
        ],
      ),
    );
  }
}
