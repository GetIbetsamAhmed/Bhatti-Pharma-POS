// ignore_for_file: prefer_final_fields, unused_field, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:async';

import 'package:bhatti_pos/screens/admin/admin_screen.dart';
import 'package:bhatti_pos/services/models/user_login.dart';
import 'package:bhatti_pos/services/utils/apiClient.dart';
import 'package:bhatti_pos/services/utils/shared_preferences.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/login_widgets/processing_indicator.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/shared/widgets/transition/left_to_right.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/widgets/others/logo_with_message.dart';
import 'package:bhatti_pos/shared/widgets/others/screen_ratio.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool showPassword = true;
  bool isPressed = false;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            closeKeyBoard();
          },
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
                      const SizedBox(height: 89),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 50),
                              // Email Field
                              SizedBox(
                                height: 48,
                                child: TextFormField(
                                  controller: _emailController,
                                  cursorColor: blueColor,
                                  cursorHeight: 22,
                                  decoration: InputDecoration(
                                    // prefixIcon: ,
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                          "assets/icons/message.svg"),
                                    ),
                                    prefixStyle:
                                        const TextStyle(color: Colors.purple),
                                    labelText: "EMAIL",
                                    floatingLabelStyle:
                                        const TextStyle(color: greyTextColor),
                                    labelStyle:
                                        const TextStyle(color: greyTextColor),
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
                                      child: SvgPicture.asset(
                                          "assets/icons/lock.svg"),
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
                                    labelStyle:
                                        const TextStyle(color: greyTextColor),
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
                              const SizedBox(height: 60),
                              InkWell(
                                onTap: () async {
                                  if (validateEmail(_emailController.text)) {
                                    closeKeyBoard();
                                    LoginWidgets.processingIndicator(context);

                                    UserLogin? loginInfo = await _login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    if (loginInfo == null) {
                                      LoginWidgets.closeProcessingIndicator(
                                          context);
                                      LoginWidgets.unsuccessfull(context);
                                    } else {
                                      LoginWidgets.closeProcessingIndicator(
                                          context);
                                      Timer? timer = Timer(
                                          const Duration(milliseconds: 1500),
                                          () {
                                        _storeData(
                                          _emailController.text,
                                          _passwordController.text,
                                          "T",
                                          loginInfo.userName!,
                                        ).whenComplete(
                                          () {
                                            _emailController.clear();
                                            _passwordController.clear();
                                            Navigator.pushReplacement(
                                              context,
                                              LTRPageRoute(
                                                const AdminScreen(),
                                                200,
                                              ),
                                            );
                                          },
                                        );
                                        Navigator.of(context).pop();
                                      });
                                      LoginWidgets.successfull(context)
                                          .then((value) {
                                        timer?.cancel();
                                        timer = null;
                                      });
                                    }
                                  } else {
                                    showToast(
                                      "Wrong email format",
                                      Colors.white,
                                    );
                                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong Email Format")));
                                  }
                                },
                                child: Container(
                                  height: 39 +
                                      MediaQuery.of(context).textScaleFactor,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: blueColor,
                                    borderRadius: borderRadius03,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Login",
                                      style: CustomTextStyle(
                                        textColor: Colors.white,
                                        weight: FontWeight.w500,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Space30v(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    // Navigator.pop(context);
    return true;
  }
}

Future<void> _storeData(
  String email,
  String password,
  String loginStatus,
  String userName,
) async {
  await PreferenceUtils.setString("data", "$email|$password|$userName");
  await PreferenceUtils.setString("loginStatus", loginStatus);
}

Future<dynamic> _login(String userEmail, String password) async {
  APIClient _apiClient = APIClient();
  var data = await _apiClient.login(userEmail, password);
  if (data == null) {
    return data;
  } else {
    UserLogin _user = UserLogin.fromJson(data);
    // _storeData(userEmail, password, "T", _user.userName!);
    UserData.userName = _user.userName!;
    return _user;
  }
}