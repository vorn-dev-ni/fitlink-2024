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
  final Widget iconButton;

  const ButtonApp({
    Key? key,
    required this.label,
    this.height = 0,
    required this.textStyle,
    required this.splashColor,
    required this.onPressed,
    this.color = Colors.blue, // Default color
    this.textColor = Colors.white, // Default text color
    this.elevation = 0.0, // Default elevation
    this.radius = 8.0, // Default border radius
    this.iconButton = const SizedBox(
      width: 0,
      height: 0,
    ),
  }) : super(key: key);

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
            backgroundColor: WidgetStatePropertyAll(color),
            overlayColor:
                WidgetStateProperty.all(splashColor.withOpacity(0.1))),
        child: Padding(
          padding: EdgeInsets.all(height ?? 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconButton,
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
