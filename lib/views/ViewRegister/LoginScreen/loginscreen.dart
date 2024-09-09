import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trainbookingapp/common/commondata/commonreference.dart';
import 'package:trainbookingapp/common/commonwidgets/commontextformfield.dart';
import 'package:trainbookingapp/common/commonwidgets/dialoghelper.dart';
import 'package:trainbookingapp/controller/RegController/LoginController/logincontroller.dart';
import 'package:trainbookingapp/views/ViewRegister/MainScreen/mainscreen.dart';
import 'package:trainbookingapp/views/ViewRegister/RegisterScreen/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginctrl = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              const Text(
                'Lets Sign you in',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text(
                'Welcome back,\nYou have been missed',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              CommonTextField(
                  controller: loginctrl.emailController,
                  hintText: 'Enter your email',
                  isPassword: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9._%+-@]+')), // for email
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email';
                    }
                    return null;
                  }),
              const SizedBox(height: 16.0),
              CommonTextField(
                controller: loginctrl.passwordController,
                hintText: 'Enter your password',
                isPassword: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9_@]+'), // Allow alphabets, numbers, _, @
                  ),
                  LengthLimitingTextInputFormatter(50)
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(color: blackColor),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await loginctrl.loginuser(context);
                  if (!loginctrl.isLoading.value &&
                      // ignore: unrelated_type_equality_checks
                      loginctrl.firstname.isNotEmpty) {
                    DialogHelper.showSuccessDialog(
                        title: "Success",
                        description: "Login Successful",
                        onConfirm: () {
                          Get.to(() => const MainScreen()); //HomeScreen()
                        });
                  }
                },
                child: Obx(() {
                  return loginctrl.isLoading.value
                      ? Center(
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(blueViolet),
                            ),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          decoration: BoxDecoration(
                            color: blueViolet,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Sign in',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ));
                }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: blackColor,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Or',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: blackColor,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              /* SignInButton(
            Buttons.Google,
            
            text: "Sign up with Google",
            onPressed: () {},
          ) */
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const RegisterScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: whiteColor,
                    elevation: 2,
                  ),
                  child: Image.asset(
                    googleLogo,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                      onPressed: () {
                        Get.to(const RegisterScreen());
                      },
                      child: const Text('Register Here'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
