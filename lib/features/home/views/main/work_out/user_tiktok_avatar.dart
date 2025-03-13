import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String name;
  final Widget avatar;
  final Color textColor;

  const UserProfile({
    Key? key,
    required this.name,
    required this.avatar,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(child: avatar),
        ),
        const SizedBox(width: 10),
        Text(
          name,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            shadows: [
              Shadow(
                offset: const Offset(2, 2),
                blurRadius: 5.0,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
