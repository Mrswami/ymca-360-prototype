import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/ymca_theme.dart';

/// Member Digital ID screen — matches the official YMCA 360 app's barcode screen.
/// Shows member name, a barcode, and a member number on a black background.
class BarcodeScreen extends ConsumerWidget {
  const BarcodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // Use the userId truncated to 10 digits as a mock member number
    final memberNumber = authState.userId != null && authState.userId!.length >= 10
        ? authState.userId!.substring(0, 10).toUpperCase()
        : '5000368225';
    const memberName = 'Jacob Moreno'; // TODO: From Firestore user profile

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done', style: TextStyle(color: Colors.blue, fontSize: 17)),
        ),
        leadingWidth: 80,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // White card matching official app
            Container(
              width: MediaQuery.of(context).size.width * 0.88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  // Member Name
                  Text(
                    memberName,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(height: 24, color: Color(0xFFE0E0E0)),

                  // Barcode (custom painted)
                  CustomPaint(
                    size: const Size(double.infinity, 140),
                    painter: _BarcodePainter(data: memberNumber),
                  ),

                  const SizedBox(height: 16),
                  // Member Number
                  Text(
                    memberNumber,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            // Page indicator dots (matching real app — multiple cards slide)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(false),
                _dot(true),  // Active
                _dot(false),
                _dot(false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 10 : 8,
      height: active ? 10 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.blue : Colors.grey.shade600,
      ),
    );
  }
}

/// Generates a simple Code 128-style barcode from a string.
class _BarcodePainter extends CustomPainter {
  final String data;
  _BarcodePainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final barWidth = size.width / (data.length * 11 + 20);
    double x = barWidth * 10;

    for (int i = 0; i < data.length; i++) {
      final code = data.codeUnitAt(i);
      // Simple deterministic bar pattern from char code
      for (int b = 0; b < 7; b++) {
        if ((code >> b) & 1 == 1) {
          canvas.drawRect(
            Rect.fromLTWH(x, 0, barWidth, size.height),
            paint,
          );
        }
        x += barWidth * 1.1;
      }
      x += barWidth * 0.5;
    }
  }

  @override
  bool shouldRepaint(_BarcodePainter old) => old.data != data;
}
