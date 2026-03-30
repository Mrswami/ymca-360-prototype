import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/ymca_theme.dart';

/// Splash screen matching the official YMCA 360 app's purple loading screen.
/// Displayed while Firebase and auth state initialize.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          colors: [
            Color(0xFFC35A1A), // Dark Orange top
            AppColors.ymcaOrange, // Primary Orange bottom
          ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: _build360Logo(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _build360Logo() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sketchy double ring — matches the real app's hand-drawn circle look
          CustomPaint(
            size: const Size(200, 200),
            painter: _SketchyRingPainter(),
          ),
          // 360 text
          const Text(
            '360',
            style: TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SketchyRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Outer ring
    canvas.drawCircle(center, radius, paint);
    // Inner ring (slightly smaller — the "sketchy double ring" look)
    paint.strokeWidth = 3.0;
    canvas.drawCircle(center, radius - 7, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
