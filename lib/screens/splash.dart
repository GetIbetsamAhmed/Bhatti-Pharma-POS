// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:bhatti_pos/services/utils/preference_utils.dart';
import 'package:bhatti_pos/shared/transition/left_to_right.dart';
import 'package:bhatti_pos/screens/admin_screen.dart';
import 'package:bhatti_pos/screens/login.dart';
import 'package:bhatti_pos/shared/widgets/logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  Future<void> getValue() async {
    SharedPreferences _instance = await SharedPreferences.getInstance();
    
    if (_instance.containsKey("loginStatus")) {
      String status = _instance.getString("loginStatus")!;
      isLoggedIn = status == "T"? true: false;

      setState(() {});
    }
    // isLoggedIn = false;
    if (kDebugMode) {
      print("user logged in? $isLoggedIn");
    }
  }

  @override
  initState() {
    super.initState();
    getValue();
    Future.delayed(const Duration(seconds: 2)).whenComplete(
      () => Navigator.of(context).pushReplacement(
        LTRPageRoute(
          isLoggedIn ? const AdminScreen() : const LoginScreen(),
          400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              child: SvgPicture.asset(
                "assets/background/elipses.svg",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          const Center(
            child: Logo(size: 300),
          ),
        ],
      ),
    );
  }
}
