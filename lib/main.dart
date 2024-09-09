import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:trainbookingapp/common/commondata/commonreference.dart';
import 'package:trainbookingapp/firebase_options.dart';
import 'package:trainbookingapp/views/ViewRegister/LoginScreen/loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          focusColor: Colors.transparent,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: blueViolet),
            ),
          ),
        ),
        title: 'UserDetails',
        home: LoginScreen());
  }
}
