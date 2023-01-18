import 'package:care_why_app/pages/lup/lup_details_page.dart';
import 'package:care_why_app/providers/lups_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';

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
    return Consumer<LupsProvider>(
      builder: (context, v, widget) {
        final lups = v.lups;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 81),
          itemCount: lups.length,
          itemBuilder: (c, i) {
            final getUserById = v.getUserById;
            final lup = v.lups[i];
            final author = getUserById(lup.authorId);

            return Container(
              color: i % 2 == 0 ? Colors.black.withOpacity(0.035) : null,
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(lups[i].imageUrl),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => LupDetailsPage(
                        lup: lup,
                        author: author,
                      ),
                    ),
                  );
                },
                title: Text(
                  lup.title,
                ),
                trailing: Text(
                    Utils.formatDateTime(
                      lup.createdAt,
                      format: "HH:mm\ndd/MM/yyyy",
                    ),
                    textAlign: TextAlign.end),
              ),
            );
          },
        );
      },
    );
  }
}
