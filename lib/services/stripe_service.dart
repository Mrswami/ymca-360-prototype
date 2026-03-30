import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StripeService {
  static final StripeService instance = StripeService._internal();

  factory StripeService() {
    return instance;
  }

  StripeService._internal();

  /// Initialize Stripe (Call this in main.dart)
  void init() {
    // Key is injected at build time via --dart-define to avoid committing to source control.
    // Run with: flutter run --dart-define=STRIPE_PK=pk_test_...
    const stripeKey = String.fromEnvironment('STRIPE_PK', defaultValue: '');
    if (stripeKey.isEmpty) {
      debugPrint('⚠️ STRIPE_PK not set. Run with --dart-define=STRIPE_PK=pk_test_...');
      return;
    }
    Stripe.publishableKey = stripeKey;
  }

  /// Main flow to manage a payment
  Future<bool> makePayment({
    required double amount, 
    required String userId, 
    required String userName
  }) async {
    if (kIsWeb) {
      return await _startWebCheckout(amount, userId: userId, userName: userName);
    }
    try {
      // 1. Create Payment Intent on Backend (Firebase Functions)
      final clientSecret = await _createPaymentIntent(amount);
      if (clientSecret == null) return false;

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'YMCA 360',
          style: ThemeMode.light, // or dark
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF0060AF), // YMCA Blue
            ),
          ),
          // AUTOFILL: Pre-fill user data
          billingDetails: BillingDetails(
            name: userName,
            email: "member@example.com", // In real app, get from Auth Profile
            phone: '555-555-5555',
            address: const Address(
              city: 'New York',
              country: 'US',
              line1: '123 Gym St',
              line2: '',
              postalCode: '10001',
              state: 'NY',
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      
      await _recordTransaction(
        type: 'Day Pass',
        amount: amount,
        status: 'succeeded',
        userId: userId,
        userName: userName,
      );

      return true; // Success
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        debugPrint("Payment Canceled");
      } else {
        debugPrint("Stripe Error: $e");
        await _recordTransaction(
          type: 'Day Pass',
          amount: amount,
          status: 'failed',
          userId: userId,
          userName: userName,
        );
      }
      return false;
    } catch (e) {
      debugPrint("General Error: $e");
      return false;
    }
  }

  /// Calls the Firebase Cloud Function
  Future<String?> _createPaymentIntent(double amount) async {
    if (kIsWeb) return null;
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
      
      // Amount in cents (Stripe format). $10.00 = 1000
      final int amountCents = (amount * 100).toInt();

      final result = await callable.call(<String, dynamic>{
        'amount': amountCents,
        'currency': 'usd',
      });

      final data = result.data as Map<dynamic, dynamic>;
      return data['clientSecret'] as String?;
    } catch (e) {
      debugPrint("Backend Error: $e");
      return null;
    }
  }
  Future<bool> _startWebCheckout(double amount, {String? userId, String? userName}) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createCheckoutSession');
      final int amountCents = (amount * 100).toInt();

      // Dynamically get the Current URL for redirect
      String currentUrl = Uri.base.origin; // e.g. http://localhost:5500 or https://xmca14.web.app
      // If we are in hash routing (flutter default), origin is enough, usually we want to return to the specific page, but home is fine/safer.
      
      final result = await callable.call(<String, dynamic>{
        'amount': amountCents,
        'currency': 'usd',
        'successUrl': '$currentUrl/', // Redirects back to your app Home
        'cancelUrl': '$currentUrl/',
        'customerEmail': 'member@example.com'
      });

      final data = result.data as Map<dynamic, dynamic>;
      final String? url = data['url'] as String?;
      
      if (url != null) {
        debugPrint("Redirecting to: $url");
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication); // webOnlyWindowName: '_self' works better for checkout
          
          await _recordTransaction(
            type: 'Day Pass (Web)',
            amount: amount,
            status: 'pending_redirect',
            userId: userId ?? 'unknown',
            userName: userName ?? 'Unknown User',
          );
          
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Web Checkout Error: $e");
      return false;
    }
  }

  Future<void> _recordTransaction({
    required String type,
    required double amount,
    required String status,
    required String userId,
    required String userName,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('transactions').add({
        'type': type,
        'amount': amount,
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
        'userName': userName,
      });
    } catch (e) {
      debugPrint("Error recording transaction: $e");
    }
  }
}
