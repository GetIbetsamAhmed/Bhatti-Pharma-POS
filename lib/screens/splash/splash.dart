// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:bhatti_pos/screens/admin/admin_screen.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/screens/login/login.dart';
import 'package:bhatti_pos/shared/widgets/others/logo.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
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
  bool isSnapshotLoaded = false;
  double loadingValue = 0.0;
  Future<void> getValue() async {
    SharedPreferences _instance = await SharedPreferences.getInstance();

    if (_instance.containsKey("loginStatus")) {
      String status = _instance.getString("loginStatus")!;
      isLoggedIn = status == "T" ? true : false;

      setState(() {});
    }
    if (_instance.containsKey("data")) {
      List data = _instance.getString("data")!.split("|");
      if (data.length > 1) {
        UserData.userName = data[2];
      }
    }
    // isLoggedIn = false;
    if (kDebugMode) print("user logged in? $isLoggedIn");
  }

  _processingData() {
    getValue();
    _fetchLoading();
  }

  _fetchLoading() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (mounted) {
        setState(() {
          loadingValue += 0.003;
        });
      }
    });
  }

  @override
  initState() {
    super.initState();
    _processingData();

    // if (isSnapshotLoaded) {
    Future.delayed(const Duration(seconds: 02)).whenComplete(
      () => Navigator.of(context).pushReplacement(
        LTRPageRoute(
          isLoggedIn ? const AdminScreen() : const LoginScreen(),
          300,
        ),
      ),
    );
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print(MediaQuery.of(context).textScaleFactor);
    return _splashUI();
  }

  _splashUI() {
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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Logo(size: 270),
                const Space20v(),
                SizedBox(
                  width: 100,
                  child: StatefulBuilder(
                    builder: (context, state) => LinearProgressIndicator(
                      backgroundColor: blueColor.withOpacity(0.1),
                      color: blueColor,
                      value: loadingValue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
