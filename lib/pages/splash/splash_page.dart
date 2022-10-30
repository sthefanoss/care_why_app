import 'package:care_why_app/pages/profile_editor/profile_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';

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
    final navigator = Navigator.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getUserFromToken();

    if (!authProvider.hasAuth) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }

    if (authProvider.authUser!.profile == null) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileEditorPage()),
      );
      return;
    }

    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
