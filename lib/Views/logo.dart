import 'dart:ui';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
   Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/logo.jpg', fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/asset.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
