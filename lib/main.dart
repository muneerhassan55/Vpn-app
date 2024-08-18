// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn/all_screens/home_page.dart';
import 'package:vpn/app_prefrences/app_prefrences.dart';

late Size screenSize;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefrences.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Free Vpn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            centerTitle: true,
            color: Colors.blue,
            elevation: 3,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        themeMode: AppPrefrences.isModeDark ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            appBarTheme: AppBarTheme(centerTitle: true, elevation: 3)),
        home: HomePage());
  }
}

extension AppTheme on ThemeData {
  Color get lightTextColor =>
      AppPrefrences.isModeDark ? Colors.white70 : Colors.black54;
  Color get bottomNaviagtionColor =>
      AppPrefrences.isModeDark ? Colors.white12 : Colors.redAccent;
}
