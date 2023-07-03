import 'package:event_app/consts/colors.dart';
import 'package:event_app/providers/user_provider.dart';
import 'package:event_app/resources/auth_gate.dart';
import 'package:event_app/resources/chat_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatMethods(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AllColors.greyS700,
            brightness: Brightness.light,
          ),
          inputDecorationTheme: const InputDecorationTheme(),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}
