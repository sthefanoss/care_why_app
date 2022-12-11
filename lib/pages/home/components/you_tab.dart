import 'package:care_why_app/pages/profile_editor/profile_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../login/login_page.dart';

class YouTab extends StatefulWidget {
  const YouTab({Key? key}) : super(key: key);

  @override
  State<YouTab> createState() => _YouTabState();
}

class _YouTabState extends State<YouTab> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _authProvider.authUser!.imageUrl;
    return Center(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          LayoutBuilder(
            builder: (_, c) => Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                    child: imageUrl != null ? null : Icon(Icons.person),
                    radius: c.maxWidth * 0.25,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Chip(
                      label: Text('\$${_authProvider.authUser!.coins}'),
                      backgroundColor: Colors.amberAccent,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
          Text(
            _authProvider.authUser!.nickname!,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            '@${_authProvider.authUser!.username}',
            textAlign: TextAlign.center,
          ),
          if (_authProvider.authUser!.isAdmin)
            Text(
              'Administrador',
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 50),
          // TextButton(
          //   onPressed: () {},
          //   child: Text('Trocar senha'),
          // ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (c) => ProfileEditorPage()));
            },
            child: Text('Atualizar perfil'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context)
                  .pushAndRemoveUntil(MaterialPageRoute(builder: (c) => LoginPage()), (route) => false);
            },
            child: Text('Sair'),
          )
        ],
      ),
    );
  }
}
