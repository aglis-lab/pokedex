import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pokedex/pages/search/Search.dart';
import 'package:pokedex/pages/detail/detail.dart';
import 'package:pokedex/helper/helper.dart';

void main() {
  Helper().init().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(seconds: 2),
      title: 'Pokedex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const SearchPage(),
        '/detail': (ctx) => const DetailPage(),
      },
    );
  }
}
