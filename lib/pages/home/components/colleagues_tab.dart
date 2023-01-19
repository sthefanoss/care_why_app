import 'package:bot_toast/bot_toast.dart';
import 'package:care_why_app/constants/constants.dart';
import 'package:care_why_app/providers/auth_provider.dart';
import 'package:care_why_app/providers/colleges_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../popups/add_exchange_popup.dart';
import '../../collegue/collegue_page.dart';

class ColleaguesTab extends StatefulWidget {
  const ColleaguesTab({required this.changeTab, Key? key}) : super(key: key);

  final ValueChanged<int> changeTab;

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
              onExchangeCompleted: () => widget.changeTab(1),
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
    required this.onExchangeCompleted,
    this.onLeaderToggle,
    this.onUserDelete,
    super.key,
  });

  final User user;

  final User authUser;

  final VoidCallback? onUserDelete;

  final ValueChanged<bool>? onLeaderToggle;

  final VoidCallback onExchangeCompleted;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.imageUrl;
    final isAuthUser = user.id == authUser.id;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
        child: imageUrl == null ? Icon(Icons.person) : null,
      ),
      title: Text('${user.nickname ?? 'Nome reservado'}${isAuthUser ? ' (Você)' : ''}'),
      subtitle: Text(
        '@${user.username}',
        style: TextStyle(color: Constants.colors.primary),
      ),
      trailing: FittedBox(
        child: Row(
          children: [
            if (user.isAdmin)
              Chip(
                label: Text('Admin', style: TextStyle(fontSize: 8)),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                backgroundColor: Constants.colors.secondary,
              ),
            if (user.isManager)
              Chip(
                label: Text('Líder', style: TextStyle(fontSize: 8)),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                backgroundColor: Constants.colors.primary,
              ),
            PopupMenuButton<String>(
              initialValue: null,
              onSelected: (item) {
                switch (item) {
                  case 'Abrir perfil':
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) => CollegePage(college: user)));
                    return;
                  case 'Excluir nome':
                    onUserDelete?.call();
                    return;
                  case 'Remover liderança':
                    onLeaderToggle?.call(false);
                    return;
                  case 'Adicionar liderança':
                    onLeaderToggle?.call(true);
                    return;
                  case 'Solicitar troca':
                    if (user.coins == 0) {
                      BotToast.showText(text: "${user.username} não possui moedas");
                      return;
                    }

                    AddExchangePopup(
                      user: user,
                      onComplete: onExchangeCompleted,
                    ).show(context);
                    return;
                }
              },
              itemBuilder: (a) {
                return [
                  if (onUserDelete == null)
                    const PopupMenuItem(
                      value: 'Abrir perfil',
                      child: Text('Abrir perfil'),
                    ),
                  if (onUserDelete != null)
                    const PopupMenuItem(
                      value: 'Excluir nome',
                      child: Text('Excluir nome'),
                    ),
                  if (onLeaderToggle != null && user.isManager)
                    const PopupMenuItem(
                      value: 'Remover liderança',
                      child: Text('Remover liderança'),
                    ),
                  if (onLeaderToggle != null && !user.isManager)
                    const PopupMenuItem(
                      value: 'Adicionar liderança',
                      child: Text('Adicionar liderança'),
                    ),
                  if (authUser.isManager || authUser.isAdmin)
                    PopupMenuItem(
                      value: 'Solicitar troca',
                      child: Text('Solicitar troca (\$ ${user.coins})'),
                    ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
