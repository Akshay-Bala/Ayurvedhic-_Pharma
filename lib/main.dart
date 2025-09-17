import 'package:flutter/material.dart';
import 'package:machine_test/Controllers/fetchPatients.dart';
import 'package:machine_test/Controllers/logincontrollr.dart';
import 'package:machine_test/Views/loginpage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => LoginController()),
    ChangeNotifierProvider(create: (_) => PatientProvider()),
  ],
  child: MyApp(),
)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: Loginpage(),
    );
  }
}
