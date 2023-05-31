import 'package:bankingapp/screens/login/cardRegistration.dart';
import 'package:flutter/material.dart';
import 'package:bankingapp/app_styles.dart';
import 'package:bankingapp/size_configs.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets/onboarding_nav_button.dart';

class onBoardingAddCard extends StatefulWidget {
  const onBoardingAddCard({Key? key}) : super(key: key);

  @override
  State<onBoardingAddCard> createState() => _onBoardingAddCardState();
}

class _onBoardingAddCardState extends State<onBoardingAddCard> {
  @override
  Widget build(BuildContext context) {
    // initialize size config
    SizeConfig().init(context);
    double sizeVertical = SizeConfig.blockSizeVertical!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: PageView.builder(
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: sizeVertical * 50,
                      child: Lottie.network(
                          "https://assets7.lottiefiles.com/packages/lf20_dfwrq0mo.json"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Conecta tu tarjeta",
                          style: kTitleOnboarding,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeVertical * 1,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Te invitamos a ingresar tus datos bancarios",
                          style: kSubtitleOnboarding,
                          maxLines: 6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeVertical * 5,
                    ),
                    OnboardingNavButton(
                      name: 'Empezar',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardRegistration(),
                          ),
                        );
                      },
                      buttonColor: kYellowColor,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
