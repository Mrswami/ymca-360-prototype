import 'package:flutter/material.dart';
import '../theme/ymca_theme.dart';

class YMCABackground extends StatelessWidget {
  final Widget child;
  final String? specificImage;

  const YMCABackground({
    super.key, 
    required this.child, 
    this.specificImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.network(
            specificImage ?? 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=2070&auto=format&fit=crop', 
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200),
          ),
        ),
        // Overlay Gradient for Readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.9), // Very light at top
                  Colors.white.withOpacity(0.95), // Solid at bottom to hide clutter
                ],
              ),
            ),
          ),
        ),
        // Content
        SafeArea(child: child),
      ],
    );
  }
}
