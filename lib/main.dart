import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox<Map>('tasks');

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),

      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: 'Flodo Task Manager',

        theme: ThemeData(

          useMaterial3: true,

          colorSchemeSeed: Colors.indigo,

          textTheme: const TextTheme(

            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),

            bodyMedium: TextStyle(
              fontSize: 14,
            ),

          ),

        ),

        home: const HomeScreen(),

      ),

    );

  }

}