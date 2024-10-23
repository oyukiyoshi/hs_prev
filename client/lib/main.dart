import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './router.dart';

void main() async {
  const envFile = String.fromEnvironment('env');
  print(envFile);
  await dotenv.load(fileName: ".env");

  const app = MyApp();
  const scope = ProviderScope(child: app);
  runApp(scope);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,  // debug ラベル
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
