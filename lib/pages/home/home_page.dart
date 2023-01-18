import 'package:care_why_app/components/money_indicator.dart';
import 'package:care_why_app/pages/home/components/colleagues_tab.dart';
import 'package:care_why_app/pages/home/components/exchanges_tab.dart';
import 'package:care_why_app/popups/add_college_popup.dart';
import 'package:care_why_app/popups/add_exchange_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../lup/new_lup_page.dart';
import 'components/lups_tab.dart';
import 'components/you_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List _pages = const <Widget>[
    LupsTab(),
    ExchangesTab(),
    ColleaguesTab(),
    YouTab(),
  ];

  final List _titles = const <String>[
    'Lições',
    'Trocas',
    'Colegas',
    'Meu perfil',
  ];
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Expanded(child: Text(_titles[_pageIndex])),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  'assets/svgs/logo.svg',
                  height: 30,
                  width: 45,
                  color: Colors.white,
                ),
              ),
            ),
            MoneyIndicator(),
          ],
        ),
      ),
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'LUPs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Trocas',
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
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, v, widget) {
          if (_pageIndex == 0) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c) => const LUPPage()));
              },
            );
          }
          if (_pageIndex == 1 && v.authUser!.canManageExchanges) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => const AddExchangePopup().show(context),
            );
          }
          if (_pageIndex == 2 && v.authUser!.canManageWorkersAccounts) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => const AddCollegePopup().show(context),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
