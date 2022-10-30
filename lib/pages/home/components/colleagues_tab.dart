import 'package:care_why_app/providers/auth_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
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
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) => Consumer<CollegesProvider>(
        builder: (_, colleges, __) => Column(
          children: [
            SizedBox(height: 20),
            if (auth.authUser!.isAdmin) ...[
              Text('Cadastrar integrante'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
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
                                  await colleges.makeUser(
                                      username:
                                          _usernameController.text.trim());
                                  await colleges.getCollegesFromApi();
                                  _usernameController.clear();
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
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: colleges.colleges.length,
                itemBuilder: (c, i) => UserTile(
                  user: colleges.colleges[i],
                  isAuthUser: colleges.colleges[i].id == auth.authUser!.id,
                  onUserDelete: !_isLoading &&
                          colleges.colleges[i].profile == null &&
                          auth.authUser!.isAdmin
                      ? () async {
                          try {
                            setState(() => _isLoading = true);
                            await colleges.deleteUser(
                                username: colleges.colleges[i].username);
                            await colleges.getCollegesFromApi();
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        }
                      : null,
                  onPasswordReset: !_isLoading && auth.authUser!.isAdmin
                      ? () async {
                          try {
                            setState(() => _isLoading = true);
                            await colleges.resetUserPassword(
                                username: colleges.colleges[i].username);
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({
    required this.user,
    required this.isAuthUser,
    Key? key,
    this.onUserDelete,
    this.onPasswordReset,
  }) : super(key: key);

  final User user;

  final bool isAuthUser;

  final VoidCallback? onUserDelete;

  final VoidCallback? onPasswordReset;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.profile?.imageUrl;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
        child: imageUrl == null ? Icon(Icons.person) : null,
      ),
      title: Text(
          '${user.profile?.nickname ?? 'Perfil Incompleto'}${isAuthUser ? ' (Você)' : ''}'),
      subtitle: Text(
        '@${user.username} ${user.isAdmin ? 'Administrador(a)' : ''}',
      ),
      trailing: onUserDelete != null || onPasswordReset != null
          ? FittedBox(
              child: Column(
                children: [
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
