import 'package:care_why_app/pages/home/components/colleagues_tab.dart';
import 'package:care_why_app/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'components/lups_tab.dart';
import 'components/you_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _pages = const <Widget>[LupsTab(), ColleaguesTab(), YouTab()];
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Why App'),
      ),
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'LUPs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_outlined),
            label: 'Colegas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Você',
          ),
        ],
        onTap: (index) => setState(() => _pageIndex = index),
        currentIndex: _pageIndex,
      ),
    );
  }
}
