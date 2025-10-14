import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature/home/presentation/home_page.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  MyApp.initialize({super.key}) {
    runApp(ProviderScope(child: MyApp()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Local Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: HomePage(),
    );
  }
}
