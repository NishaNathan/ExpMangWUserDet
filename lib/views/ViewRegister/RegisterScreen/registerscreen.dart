import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trainbookingapp/common/commonwidgets/commondob.dart';
import 'package:trainbookingapp/common/commondata/commonlist.dart';
import 'package:trainbookingapp/common/commondata/commonreference.dart';
import 'package:trainbookingapp/common/commonwidgets/commontextformfield.dart';
import 'package:trainbookingapp/common/commonwidgets/dialoghelper.dart';
import 'package:trainbookingapp/controller/RegController/RegisterController/registercontroller.dart';
import 'package:trainbookingapp/views/ViewRegister/LoginScreen/loginscreen.dart';

import '../../../common/commonwidgets/commondropdown.dart';
import '../../../common/commonwidgets/commoncheckbox.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterDetController regCtrl = Get.put(RegisterDetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              const Text(
                'Lets Register Account',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const Text(
                'Hello user,have a grateful journey',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              CommonTextField(
                hintText: 'First Name',
                isPassword: false,
                controller: regCtrl.firstNameController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+')),
                  LengthLimitingTextInputFormatter(25)
                ],
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter First Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CommonTextField(
                hintText: 'Last Name',
                isPassword: false,
                controller: regCtrl.lastNameController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]+')),
                  LengthLimitingTextInputFormatter(25)
                ],
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Last Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CommonTextField(
                  hintText: 'Email',
                  isPassword: false,
                  controller: regCtrl.emailController,
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
                hintText: 'Mobile Number',
                isPassword: false,
                controller: regCtrl.mobileNumberController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Mobile Number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CommonTextField(
                hintText: 'Password',
                isPassword: true,
                controller: regCtrl.passwordController,
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
              const SizedBox(height: 16.0),
              DateOfBirthWidget(
                labelText: 'Date of Birth',
                controller: regCtrl.dobController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Date of Birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CommonDropDown(
                  prefixicon: false,
                  borderColor: Colors.black,
                  label: 'State',
                  value: regCtrl.selectedState.value,
                  items: statesInIndia,
                  prefixiconData: Icons.alarm,
                  suffixIconData: Icons.keyboard_arrow_down_sharp,
                  onChanged: (String? newValue) {
                    setState(() {
                      regCtrl.selectedState.value = newValue ?? '';
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CommonDropDown(
                  prefixicon: false,
                  borderColor: Colors.black,
                  label: 'Country',
                  value: regCtrl.selectedCountry.value,
                  items: countries,
                  prefixiconData: Icons.alarm,
                  suffixIconData: Icons.keyboard_arrow_down_sharp,
                  onChanged: (String? newValue) {
                    setState(() {
                      regCtrl.selectedCountry.value = newValue ?? '';
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => CustomCheckbox(
                        value: regCtrl.acceptedTerms.value,
                        onChanged: (value) {
                          regCtrl.acceptedTerms.value = value!;
                        },
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'I Accept the terms and condition',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              GestureDetector(
                onTap: () async {
                  String? emptyCheck = regCtrl.validateAllFields();

                  if (emptyCheck == null) {
                    String? termsError = regCtrl.validateTermsAndConditions();

                    if (termsError == null) {
                      await regCtrl.saveregisteruser(context);
                      if (!regCtrl.isLoading.value) {
                        DialogHelper.showSuccessDialog(
                            title: "Success",
                            description: "Registration Successful",
                            onConfirm: () {
                              Get.to(const LoginScreen());
                            });
                      }
                    } else {
                      DialogHelper.showErrorDialog(
                          title: "Error", description: termsError);
                    }
                  } else {
                    DialogHelper.showErrorDialog(
                        title: "Error", description: emptyCheck);
                  }
                },
                child: Obx(() {
                  return regCtrl.isLoading.value
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
                              'Sign up',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an Account?'),
                  TextButton(
                    onPressed: () {
                      Get.to(const LoginScreen());
                    },
                    child: const Text('Login'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
