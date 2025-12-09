import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/user_storage_service.dart';
import 'services/theme_storage_service.dart';
import 'viewmodels/users_view_model.dart';
import 'viewmodels/theme_view_model.dart';
import 'views/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              UsersViewModel(UserStorageService())..loadUsers(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ThemeViewModel(ThemeStorageService())..loadTheme(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVm = context.watch<ThemeViewModel>();

    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'MVVM Users App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeVm.themeMode,
      home: const HomeScreen(),
      
    );
  }
}
