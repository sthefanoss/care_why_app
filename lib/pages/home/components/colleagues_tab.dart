import 'package:care_why_app/providers/colleges_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';

class ColleaguesTab extends StatefulWidget {
  const ColleaguesTab({Key? key}) : super(key: key);

  @override
  State<ColleaguesTab> createState() => _ColleaguesTabState();
}

class _ColleaguesTabState extends State<ColleaguesTab> {
  @override
  Widget build(BuildContext context) {
    final collegesProvider = Provider.of<CollegesProvider>(context);
    final colleges = collegesProvider.colleges;

    return ListView.builder(
      itemCount: colleges.length,
      itemBuilder: (c, i) => UserTile(user: colleges[i]),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({required this.user, Key? key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.imageUrl),
      ),
      title: Text(user.name),
    );
  }
}
