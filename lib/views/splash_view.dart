import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';

import 'home_view.dart';
import 'my_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return const HomeView();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Center(
          child: FadedScaleAnimation(
              child: const Text(
        "Voice to Text",
        style: TextStyle(
          color: MyColors.whiteColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ))),
    );
  }
}
