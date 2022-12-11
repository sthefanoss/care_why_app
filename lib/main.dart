import 'package:care_why_app/pages/splash/splash_page.dart';
import 'package:care_why_app/providers/colleges_providers.dart';
import 'package:care_why_app/providers/lups_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'providers/auth_provider.dart';
import 'providers/exchanges_provider.dart';
import 'services/local_storage.dart';
import 'services/http_client.dart';

void main() async {
  await LocalStorage.init();
  HttpClient.interceptors.add(ErrorObserverInterceptor());
  setPathUrlStrategy();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => CollegesProvider()),
      ChangeNotifierProvider(create: (_) => LupsProvider()),
      ChangeNotifierProvider(create: (_) => ExchangesProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(),
        ),
        routes: {
          '/': (c) => const SplashPage(),
        },
        builder: (context, widget) => GestureDetector(
              onTap: FocusManager.instance.primaryFocus?.unfocus,
              child: Builder(
                builder: (context) {
                  const maxWidth = 520.0;
                  if (MediaQuery.of(context).size.width <= maxWidth) {
                    return widget ?? Container();
                  }
                  return Container(
                    color: Colors.grey,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              spreadRadius: 2,
                              blurRadius: 10)
                        ]),
                        constraints: const BoxConstraints(maxWidth: maxWidth),
                        child: widget,
                      ),
                    ),
                  );
                },
              ),
            ));
  }
}
