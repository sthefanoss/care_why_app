import 'package:flutter/material.dart';

import '../../../models/user.dart';

class LupParticipantChip extends StatelessWidget {
  const LupParticipantChip({
    required this.participant,
    this.isAuthor = false,
    this.selected = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final User participant;

  final bool isAuthor;

  final bool selected;

  final ValueChanged<User>? onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = participant.imageUrl;

    return GestureDetector(
      onTap: onTap != null ? () => onTap!.call(participant) : null,
      child: Chip(
        backgroundColor: selected ? Theme.of(context).primaryColor : null,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null ? Icon(Icons.person) : null,
            ),
            Flexible(child: Text(participant.nickname!))
          ],
        ),
      ),
    );
  }
}
