import 'package:care_why_app/providers/colleges_providers.dart';
import 'package:care_why_app/providers/lups_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home/home_page.dart';
import '../signup/signup_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    _loadUserDataAndRedirect();
    super.didChangeDependencies();
  }

  void _loadUserDataAndRedirect() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hasAuth = await authProvider.checkUserData();

    if (!hasAuth) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SignupPage(),
        ),
      );
      return;
    }
    await Future.wait([
      Provider.of<CollegesProvider>(context, listen: false)
          .getCollegesFromApi(),
      Provider.of<LupsProvider>(context, listen: false).getLupsFromApi(),
    ]);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
