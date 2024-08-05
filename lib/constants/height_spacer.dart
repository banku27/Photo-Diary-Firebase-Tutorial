import 'package:flutter/material.dart';

class HeightSpacer extends StatelessWidget {
  final double height;
  const HeightSpacer({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
