import 'package:flutter/material.dart';
import '../theme/ymca_theme.dart';
import 'home_screen.dart'; // We'll navigate to mainshell actually logic in main.dart? 
// Actually we should navigate to a Login Screen or MainShell. 
// For demo, Log In could just go straight to MainShell.

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onLogin;

  const WelcomeScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Dark Overlay
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=2070&auto=format&fit=crop', // Cycling/Gym dark
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: Colors.black);
              },
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ),
          ),
          // Dark Gradient Overlay for Readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          
          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('YMCA 360', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text('Privacy', style: TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(width: 16),
                      Text('Terms', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text Content
                const Text(
                  'For the Y, By the Y',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "YMCA360 is where YMCA's people, places, and programs are at the tip of your fingers.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // Dots Indicator (Cosmetic)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0 ? AppColors.ymcaBlue : Colors.grey.shade600,
                    ),
                  )),
                ),
                const SizedBox(height: 32),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ymcaBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Log In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                           // Blank button as requested
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.ymcaBlue, // or slightly different shade?
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Wellness', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}
