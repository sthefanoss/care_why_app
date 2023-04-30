import 'package:flutter/material.dart';

import '../../components/image_picker.dart';
import '../../models/lup.dart';
import '../../models/user.dart';
import '../../utils/utils.dart';
import '../collegue/collegue_page.dart';

class LupDetailsPage extends StatelessWidget {
  const LupDetailsPage({required this.lup, required this.author, Key? key}) : super(key: key);

  final Lup lup;

  final User author;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lição'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text('Nome da lição'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(lup.title),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (c) => CollegePage(college: author),
                            ),
                          );
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            label: Text('Criador'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text('@${author.username}'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: InputDecorator(
                        decoration: InputDecoration(
                          label: Text('Data'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          Utils.formatDateTime(lup.createdAt, format: 'dd/MM/yyyy'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                InputDecorator(
                  decoration: InputDecoration(
                    label: Text('Categoria'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(lup.type),
                ),
                const SizedBox(height: 20),
                ImageSelector(currentSelectedImage: lup.imageUrl, onChanged: null),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Voltar'),
              onPressed: Navigator.of(context).pop,
            ),
          ),
        ),
      ),
    );
  }
}
