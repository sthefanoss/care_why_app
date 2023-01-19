import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
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
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final botToastBuilder = BotToastInit();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //1. call BotToastInit
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xFFFF9900),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD600),
                foregroundColor:  Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            textButtonTheme:
                TextButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.resolveWith((states) {
              return TextStyle(color: Colors.red, fontSize: 12);
            })))),
        routes: {
          '/': (c) => const SplashPage(),
        },
        builder: (context, widget) {
          widget = botToastBuilder(context, widget);
          return GestureDetector(
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
                      decoration:
                          BoxDecoration(boxShadow: [BoxShadow(color: Colors.black54, spreadRadius: 2, blurRadius: 10)]),
                      constraints: const BoxConstraints(maxWidth: maxWidth),
                      child: widget,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
