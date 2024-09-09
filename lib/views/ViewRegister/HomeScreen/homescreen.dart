import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trainbookingapp/common/commondata/commonreference.dart';

import '../../../controller/RegController/HomeController/homecontroller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeCtrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (homeCtrl.isError.value) {
          return Center(
            child: Text(
              homeCtrl.errorMessage.value,
              style: const TextStyle(
                  color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        } else if (homeCtrl.usersList.isEmpty) {
          return ListView.builder(
            itemCount: 6, 
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        radius: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 15,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 100,
                            height: 15,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 120,
                            height: 15,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return ListView.builder(
            
            itemCount: homeCtrl.usersList.length,
            itemBuilder: (context, index) {
              final user = homeCtrl.usersList[index];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 25,
                          child: Icon(
                            Icons.person,
                            color: blueViolet,
                            size: 25,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.firstName} ${user.lastName}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                            Text(user.email),
                            Text(user.mobileNumber),
                          ],
                        ),
                      ],
                    ),
                  /*   const SizedBox(
                      height: 10,
                    ) */
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
