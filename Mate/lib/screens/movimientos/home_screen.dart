import 'package:flutter/material.dart';
import 'components/body.dart';

class HomeScreenMovimientos extends StatelessWidget {
  const HomeScreenMovimientos({super.key});

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

    );
  }
}
