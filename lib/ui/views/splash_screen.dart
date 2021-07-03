import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nice_intro/intro_screen.dart';
import 'package:nice_intro/intro_screens.dart';
import 'package:student_side/ui/views/auth_page.dart';
import 'package:student_side/ui/views/login/login_view.dart';
import 'package:student_side/ui/views/login_page.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:tinycolor/tinycolor.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  List<IntroScreen> pages = [
    IntroScreen(
      title: 'لاخبار',
      imageAsset: 'assets/images/slide1.webp',
      description: ' احصل على أخر الاخبار',
      headerBgColor: Colors.white,
    ),
    IntroScreen(
      title: 'التواصل مع الاساتذة',
      headerBgColor: Colors.white,
      imageAsset: 'assets/images/slide2.webp',
      description: "بإمكانك التواصل مع الاستاذ و الاستفسار ",
    ),
    IntroScreen(
      title: 'Social',
      headerBgColor: Colors.white,
      imageAsset: 'assets/images/slide3.webp',
      description: "Keep talking with your mates",
    ),
  ];
  @override
  Widget build(BuildContext context) {

    IntroScreens introScreens = IntroScreens(
      onDone: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginView(),
        ),
      ),
      onSkip: () =>Get.to(LoginView()),
      footerBgColor: AppColors.greenColor,
      activeDotColor: Colors.white,
      footerRadius: 18.0,
      indicatorType: IndicatorType.CIRCLE,
      slides: pages,);
   return Scaffold(
      body: introScreens,
    );
  }
}