import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: const [Body()],
      ),
      appBar: buildAppBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      centerTitle: false,
      title: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage("assets/images/walmart.png"),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: SvgPicture.asset("assets/icons/notifs.svg"),
        )
      ],
    );
  }
}
