import 'package:care_why_app/providers/auth_provider.dart';
import 'package:care_why_app/providers/colleges_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../collegue/collegue_page.dart';

class ColleaguesTab extends StatefulWidget {
  const ColleaguesTab({Key? key}) : super(key: key);

  @override
  State<ColleaguesTab> createState() => _ColleaguesTabState();
}

class _ColleaguesTabState extends State<ColleaguesTab> {
  bool _isLoading = true;
  late final CollegesProvider collegesProvider;

  @override
  void initState() {
    collegesProvider = Provider.of<CollegesProvider>(context, listen: false);
    collegesProvider.getCollegesFromApi().then((value) {
      setState(() {
        if (mounted) _isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        if (mounted) _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) => Consumer<CollegesProvider>(
        builder: (_, colleges, __) => ListView.builder(
          padding: const EdgeInsets.only(bottom: 81),
          itemCount: colleges.colleges.length,
          itemBuilder: (c, i) => Container(
            color: i % 2 == 0 ? Colors.black.withOpacity(0.035) : null,
            child: UserTile(
              user: colleges.colleges[i],
              authUser: auth.authUser!,
              onUserDelete: !_isLoading &&
                      colleges.colleges[i].nickname == null &&
                      (auth.authUser!.isAdmin || auth.authUser!.isManager)
                  ? () async {
                      try {
                        setState(() => _isLoading = true);
                        await colleges.deleteUser(username: colleges.colleges[i].username);
                        await colleges.getCollegesFromApi();
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    }
                  : null,
              onLeaderToggle: (value) async {
                if (_isLoading) {
                  return;
                }
                if (!auth.authUser!.isAdmin) {
                  return;
                }
                try {
                  setState(() => _isLoading = true);
                  await colleges.managerToggle(
                    username: colleges.colleges[i].username,
                    value: value,
                  );
                  await collegesProvider.getCollegesFromApi();
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({
    required this.user,
    required this.authUser,
    this.onLeaderToggle,
    this.onUserDelete,
    this.showActions = true,
    super.key,
  });

  final User user;

  final User authUser;

  final VoidCallback? onUserDelete;

  final ValueChanged<bool>? onLeaderToggle;

  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.imageUrl;
    final isAuthUser = user.id == authUser.id;
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (c) => CollegePage(college: user)));
      },
      leading: CircleAvatar(
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
        child: imageUrl == null ? Icon(Icons.person) : null,
      ),
      title: Text('${user.nickname ?? 'Perfil Incompleto'}${isAuthUser ? ' (Você)' : ''}'),
      subtitle: Text(
        '@${user.username} ${user.isAdmin ? 'Administrador(a)' : ''}',
      ),
      trailing: showActions && (authUser.isAdmin || authUser.isManager)
          ? FittedBox(
              child: Row(
                children: [
                  if (!user.isAdmin)
                    Column(
                      children: [
                        Text('Líder'),
                        Switch(value: user.isManager, onChanged: onLeaderToggle),
                      ],
                    ),
                  TextButton(onPressed: onUserDelete, child: Text('Deletar')),
                  // TextButton(
                  //     onPressed: onPasswordReset, child: Text('Resetar senha'))
                ],
              ),
            )
          : null,
    );
  }
}
