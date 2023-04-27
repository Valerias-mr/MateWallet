/*import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = Tween<double>(begin: 0, end: 1);

    return PlayAnimation<double>(
      tween: tween,
      duration: Duration(milliseconds: 500),
      delay: Duration(milliseconds: (500 * delay).round()),
      curve: Curves.easeOut,
      builder: (context, child, value) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}*/
