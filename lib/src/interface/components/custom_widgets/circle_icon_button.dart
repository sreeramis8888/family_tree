import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleIconButton extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final double size;
  final VoidCallback? onTap;
  final String text;
  const CircleIconButton({
    super.key,
    required this.icon,
    this.iconColor = kPrimaryColor,
    this.size = 56,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center, // Center the icon inside the circle
            child: SvgPicture.asset(
              icon,
              color: iconColor,
              width: size * 0.5, // Icon size relative to button size
              height: size * 0.5,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          text,
          style: kSmallerTitleR,
        )
      ],
    );
  }
}
