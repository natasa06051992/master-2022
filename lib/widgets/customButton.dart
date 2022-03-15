import 'package:flutter/material.dart';
import 'package:flutter_master/config/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.height = 40,
    this.width = 220,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final double height;
  final double width;
  final Widget child;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(green),
          ),
          child: child,
          onPressed: () {
            onPressed();
          }),
    );
  }
}
