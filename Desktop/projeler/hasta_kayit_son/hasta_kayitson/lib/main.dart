import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/hasta_controller.dart';
import 'controller/doktor_controller.dart';
import 'controller/theme_controller.dart';
import 'pages/home_page.dart';
import 'pages/doktor_hasta_listesi_page.dart';
import 'pages/hasta_giris_page.dart';

void main() {
  Get.put(ThemeController());
  Get.put(HastaController());
  Get.put(DoktorController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        title: 'Hasta Kayıt Sistemi',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        getPages: [
          GetPage(
            name: '/doktor_hasta_listesi',
            page: () => const DoktorHastaListesiPage(),
          ),
          GetPage(name: '/hasta_giris', page: () => HastaGirisPage()),
        ],
      ),
    );
  }
}
