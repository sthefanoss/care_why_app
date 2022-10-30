import 'package:care_why_app/pages/lup/lup_details_page.dart';
import 'package:care_why_app/pages/lup/new_lup_page.dart';
import 'package:care_why_app/providers/lups_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LupsTab extends StatefulWidget {
  const LupsTab({Key? key}) : super(key: key);

  @override
  State<LupsTab> createState() => _LupsTabState();
}

class _LupsTabState extends State<LupsTab> {
  late final LupsProvider _lupsProvider;

  @override
  void initState() {
    _lupsProvider = Provider.of<LupsProvider>(context, listen: false);
    _lupsProvider.getLupsFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => LUPPage()));
            },
            child: Text('Registrar LUP')),
        Expanded(
          child: Consumer<LupsProvider>(builder: (context, v, widget) {
            final lups = v.lups;
            return ListView.builder(
              itemCount: lups.length,
              itemBuilder: (c, i) {
                final lup = lups[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(lups[i].imageUrl),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => LupDetailsPage(
                          lup: lups[i],
                        ),
                      ),
                    );
                  },
                  title: Text(lup.title),
                  // subtitle: Text(
                  //     'Autor: ${lup.author.name}${lup.collaborators.isNotEmpty ? '\nAjudantes: ' + lup.collaborators.map((e) => e.name).reduce((value, element) => '$value, $element') : ''}'),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
