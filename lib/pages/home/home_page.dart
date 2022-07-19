import 'package:care_why_app/pages/home/components/colleagues_tab.dart';
import 'package:flutter/material.dart';

import 'components/lups_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _pages = const <Widget>[LupsTab(), ColleaguesTab()];
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
            icon: Icon(Icons.person),
            label: 'Participantes',
          ),
        ],
        onTap: (index) => setState(() => _pageIndex = index),
        currentIndex: _pageIndex,
      ),
    );
  }
}

class Foo extends StatelessWidget {
  Foo({required this.boo, Key? key}) : super(key: key);

  int boo;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
