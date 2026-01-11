import 'package:flutter/material.dart';
import '../theme/ymca_theme.dart';

class IncomeVerificationScreen extends StatefulWidget {
  const IncomeVerificationScreen({super.key});

  @override
  State<IncomeVerificationScreen> createState() => _IncomeVerificationScreenState();
}

class _IncomeVerificationScreenState extends State<IncomeVerificationScreen> {
  bool _isUploading = false;
  bool _isSuccess = false;
  String? _fileName;

  Future<void> _mockUpload() async {
    setState(() => _isUploading = true);
    
    // Simulate Network
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isUploading = false;
      _fileName = "paystub_2025.jpg"; 
    });
  }

  Future<void> _submit() async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isUploading = false;
      _isSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) return _buildSuccessView();

    return Scaffold(
      appBar: AppBar(title: const Text('Income Verification')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.security, size: 60, color: AppColors.ymcaBlue),
            const SizedBox(height: 16),
            const Text(
              'Membership for All (MFA)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'To maintain your discount, please upload a copy of your most recent pay stub or tax return.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Upload Area
            GestureDetector(
              onTap: _fileName == null ? _mockUpload : null,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade400, style: BorderStyle.none), // Dotted border ideally
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_fileName != null) ...[
                            const Icon(Icons.check_circle, color: Colors.green, size: 40),
                            const SizedBox(height: 8),
                            Text(_fileName!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextButton(onPressed: () => setState(() => _fileName = null), child: const Text('Remove'))
                          ] else ...[
                            const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.blue),
                            const SizedBox(height: 8),
                            const Text('Tap to Upload Document', style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text('Supports JPG, PNG, PDF', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ]
                        ],
                      ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _fileName != null ? _submit : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.ymcaBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit for Review'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              const Text('Submission Received', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Our Membership Director will review your documents within 24-48 hours. You will receive a notification once approved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
