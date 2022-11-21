import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class LTRPageRoute extends PageRouteBuilder {
  final Widget child;
  final int duration;
  LTRPageRoute(this.child, this.duration)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return child;
          },  
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  // end: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: duration),
        );
}
