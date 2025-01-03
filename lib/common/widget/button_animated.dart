import 'package:flutter/material.dart';

class AnimatedButtonScale extends StatefulWidget {
  const AnimatedButtonScale({super.key});
  @override
  State<AnimatedButtonScale> createState() => _AnimatedButtonScaleState();
}

class _AnimatedButtonScaleState extends State<AnimatedButtonScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationButtonController;

  late Animation<double> _buttonScale;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _animationButtonController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        animationBehavior: AnimationBehavior.normal);
    _buttonScale = Tween(begin: 1.0, end: 1.2)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_animationButtonController);

    _animationButtonController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _animationButtonController.reverse();
        }
      },
    );
  }

  @override
  void dispose() {
    _animationButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationButtonController,
        builder: (context, child) {
          return ScaleTransition(
            scale: _buttonScale,
            child: child,
          );
        },
        child: ElevatedButton(
            style: const ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.black),
                backgroundColor:
                    WidgetStatePropertyAll(Color.fromARGB(255, 231, 181, 28))),
            onPressed: () => {_animationButtonController.forward()},
            child: Text('Add to cart')));
  }
}
