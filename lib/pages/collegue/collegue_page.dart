import 'package:care_why_app/pages/profile_editor/profile_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../models/user.dart';

class CollegePage extends StatefulWidget {
  const CollegePage({required this.college, super.key});

  final User college;

  @override
  State<CollegePage> createState() => _CollegePageState();
}

class _CollegePageState extends State<CollegePage> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).getUserFromToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (c, auth, _) {
      final imageUrl = widget.college.imageUrl;

      return Scaffold(
        appBar: AppBar(
          title: Text('Perfil @${widget.college.username}'),
        ),
        body: ListView(
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
                        child: Text('\$ ${widget.college.coins}'),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              widget.college.nickname ?? '',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              '@${widget.college.username}',
              textAlign: TextAlign.center,
            ),
            if (widget.college.isAdmin)
              Text(
                'Administrador',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (widget.college.isManager)
              Text(
                'Líder',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 50),
          ],
        ),
      );
    });
  }
}
