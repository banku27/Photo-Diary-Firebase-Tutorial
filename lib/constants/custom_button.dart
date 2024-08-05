import 'package:flutter/material.dart';
import 'package:photo_diary_firebase/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool disable;
  final VoidCallback onTap;
  final double height;
  final double width;
  const CustomButton(
      {super.key,
      required this.text,
      required this.color,
      this.disable = false,
      required this.onTap,
      this.height = 50,
      this.width = double.maxFinite});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: disable ? AppColor.kGrey : AppColor.kPrimaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
