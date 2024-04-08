import 'package:flutter_3_13/models/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'models/projects_manager.dart';
import 'pages/pages.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => FileProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProjectManager(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'SignikaNegative',
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'SignikaNegative',
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),),
      home: const MyHomePage(),
    );
  }
}
