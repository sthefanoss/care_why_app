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
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).getUserFromToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (c, auth, _) {
      final imageUrl = auth.authUser?.imageUrl;

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
                    child: CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                      child: Text('\$ ${auth.authUser!.coins}'),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
          Text(
            auth.authUser?.nickname ?? '',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            '@${auth.authUser?.username}',
            textAlign: TextAlign.center,
          ),
          if (auth.authUser?.isAdmin ?? false)
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
      );
    });
  }
}
