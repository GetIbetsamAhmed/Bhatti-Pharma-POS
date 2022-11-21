// ignore_for_file: prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers

import 'package:bhatti_pos/services/utils/preference_utils.dart';
import 'package:bhatti_pos/shared/transition/left_to_right.dart';
import 'package:bhatti_pos/screens/admin_screen.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/widgets/custom_button.dart';
import 'package:bhatti_pos/shared/widgets/logo_with_message.dart';
import 'package:bhatti_pos/shared/widgets/screen_ratio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool showPassword = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  String validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    String returnValue = "";
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      returnValue = "Enter a valid email address";
    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 500,
                width: 500,
                child: SvgPicture.asset(
                  'assets/background/elipses.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            ScreenRatio(
              child: Column(
                children: [
                  const LogoWithMessage(
                    message1: "Welcome Back",
                    message2: "Login to continue",
                  ),
                  const Space30v(),
                  const Space30v(),
                  const Space30v(),
                  const Space20v(),
                  SizedBox(
                    height: 48,
                    child: TextFormField(
                      controller: _emailController,
                      cursorColor: blueColor,
                      cursorHeight: 22,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        // prefixIcon: ,
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(12),
                          child: SvgPicture.asset("assets/icons/message.svg"),
                        ),
                        prefixStyle: const TextStyle(color: Colors.purple),
                        labelText: "EMAIL",
                        floatingLabelStyle:
                            const TextStyle(color: greyTextColor),
                        labelStyle: const TextStyle(color: greyTextColor),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: borderSide,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: borderSide,
                        ),
                      ),
                    ),
                  ),
                  const Space30v(),
                  SizedBox(
                    height: 48,
                    child: TextFormField(
                      controller: _passwordController,
                      cursorColor: blueColor,
                      cursorHeight: 22,
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(12),
                          child: SvgPicture.asset("assets/icons/lock.svg"),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility_rounded,
                            color: blueColor,
                          ),
                        ),
                        suffixIconColor: blueColor,
                        labelText: "PASSWORD",
                        labelStyle: const TextStyle(color: greyTextColor),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x0A000000),
                            strokeAlign: StrokeAlign.outside,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: borderColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Space30v(),
                  const Space30v(),
                  CustomElevatedButton(
                    onTap: () {
                      _storeData(
                        _emailController.text,
                        _passwordController.text,
                        "T",
                      ).whenComplete(() {
                        Navigator.pushReplacement(
                          context,
                          LTRPageRoute(
                            const AdminScreen(),
                            300,
                          ),
                        );
                      });
                      _emailController.clear();
                      _passwordController.clear();
                    },
                    color: blueColor,
                    text: "Login",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _storeData(String email, String password, String loginStatus) async {
  // SharedPreferences _instance = await SharedPreferences.getInstance();
  // await _instance.setString("data", "$email|$password");
  // await _instance.setBool("loginStatus", loginStatus);
  await PreferenceUtils.setString("data", "$email|$password");
  await PreferenceUtils.setString("loginStatus", loginStatus);
}
