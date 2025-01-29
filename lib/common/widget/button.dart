import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/button/elevation_theme.dart';
import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color splashColor;
  final Color textColor;
  final double elevation;
  final double radius;
  final TextStyle textStyle;
  final double? height;
  final Widget? iconButton;

  const ButtonApp(
      {super.key,
      required this.label,
      this.height = 0,
      required this.textStyle,
      required this.splashColor,
      required this.onPressed,
      this.color = Colors.blue, // Default color
      this.textColor = Colors.white, // Default text color
      this.elevation = 0.0, // Default elevation
      this.radius = 0, // Default border radius
      this.iconButton});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ElevatedButton(
        onPressed: onPressed,
        clipBehavior: Clip.hardEdge,
        style: ElevationTheme.elevationButtonLight.style?.copyWith(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return 0;
              }
              return 0;
            }),
            shape: radius > 0
                ? const WidgetStatePropertyAll(CircleBorder(eccentricity: 0))
                : WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))),
            padding: WidgetStatePropertyAll(EdgeInsets.all(radius)),
            backgroundColor: WidgetStatePropertyAll(color),
            overlayColor:
                WidgetStateProperty.all(splashColor.withOpacity(0.1))),
        child: Padding(
          padding: EdgeInsets.all(height ?? 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconButton != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
                  child: iconButton!,
                ),
              Text(
                label,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
