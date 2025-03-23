import 'package:flutter/material.dart';

class OnlyScrollUpWard extends ScrollPhysics {
  OnlyScrollUpWard({required ScrollPhysics? parent}) : super(parent: parent);

  bool isGoingDown = false;

  @override
  OnlyScrollUpWard applyTo(ScrollPhysics? ancestor) {
    return OnlyScrollUpWard(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    isGoingDown = offset > 0; // Positive offset means swiping down (forward)
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // Prevent downward scrolling (swiping down)
    if (isGoingDown) {
      // Block forward scrolling if we're at the last page (maxScrollExtent)
      if (position.pixels == position.maxScrollExtent) {
        return 0.0; // Prevent scroll
      }
    }

    // Allow upward scroll (swiping up)
    if (!isGoingDown) {
      return value - position.pixels; // Allow backward scroll (upward)
    }

    // Handle all other boundary conditions normally
    return 0.0;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true; // Always accept the user's scroll input
  }
}
