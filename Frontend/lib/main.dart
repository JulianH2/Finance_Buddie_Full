import 'package:finance_buddie/provider/AuthProvider.dart';
import 'package:finance_buddie/provider/ThemeProvider.dart';
import 'package:finance_buddie/screens/SplashScreen.dart';
import 'package:finance_buddie/services/AuthService.dart';
import 'package:finance_buddie/services/BuddieService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/TransaccionesProvider.dart';
import '../provider/BuddieProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => AuthService()), // Provee el servicio
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
          update:
              (context, authService, authProvider) =>
                  authProvider ?? AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create:
              (_) =>
                  TransaccionesProvider(), // Sin parámetros si no son necesarios
        ),
        ChangeNotifierProvider(
          create:
              (context) => BuddieProvider(
                BuddieService(
                  email: 'user@example.com',
                ), // Reemplaza con el email real
              ),
        ),
      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Buddie',
      theme: ThemeData.light().copyWith(
        primaryColor: themeProvider.primaryColor,
        colorScheme: ColorScheme.light(
          primary: themeProvider.primaryColor,
          secondary: themeProvider.accentColor,
        ),
        scaffoldBackgroundColor: themeProvider.backgroundColor,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: themeProvider.primaryColor,
        colorScheme: ColorScheme.dark(
          primary: themeProvider.primaryColor,
          secondary: themeProvider.accentColor,
        ),
        scaffoldBackgroundColor: themeProvider.backgroundColor,
      ),
      themeMode: themeProvider.themeMode,
      home: SplashScreen(),
    );
  }
}
