import 'package:flutter/material.dart';

enum TransitionType { fade, slide, scale, rotation, combined }

void goto(BuildContext context, Widget page, TransitionType transitionType) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: 700), // ⏳ زيادة مدة الأنيميشن
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutBack, // 🎯 منحنى حركة واضح وسلس
        );

        switch (transitionType) {
          case TransitionType.fade:
            return FadeTransition(opacity: curvedAnimation, child: child);

          case TransitionType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.5, 0), // 📌 يبدأ أبعد لجعل الدخول واضحًا
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case TransitionType.scale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.2, end: 1.0)
                  .animate(curvedAnimation), // ⬆️ يبدأ بحجم صغير جدًا
              child: child,
            );

          case TransitionType.rotation:
            return RotationTransition(
              turns: Tween<double>(begin: -0.5, end: 0.0)
                  .animate(curvedAnimation), // 🔄 يدور بشكل واضح
              child: child,
            );

          case TransitionType.combined:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.5, 0), // 🔄 يبدأ بعيدًا جدًا ليكون واضحًا
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.2, end: 1.0)
                    .animate(curvedAnimation),
                child: RotationTransition(
                  turns: Tween<double>(begin: -0.5, end: 0.0)
                      .animate(curvedAnimation),
                  child: child,
                ),
              ),
            );

          // ignore: unreachable_switch_default
          default:
            return child;
        }
      },
    ),
  );
}
