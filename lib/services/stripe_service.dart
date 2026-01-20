import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeService {
  static final StripeService instance = StripeService._internal();

  factory StripeService() {
    return instance;
  }

  StripeService._internal();

  /// Initialize Stripe (Call this in main.dart)
  void init() {
    // TODO: Replace with your Publishable Key from Stripe Dashboard
    Stripe.publishableKey = "pk_test_51NwLAvDyP48nofc82aAQ2TeeCfBbw1xPjN7TloZzPlWBVRcRu9dSTMCfd1pYMXWLMJkaEHc40rmvRL30tS2eGx7V00qtBQw63e"; 
    // Usually starts with pk_test_...
    
    // if (kIsWeb) {
    //   await Stripe.instance.applySettings();
    // }
  }

  /// Main flow to manage a payment
  Future<bool> makePayment(double amount) async {
    if (kIsWeb) {
      return await _startWebCheckout(amount);
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
        ),
      );

      // 3. Display Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      return true; // Success
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        debugPrint("Payment Canceled");
      } else {
        debugPrint("Stripe Error: $e");
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
  Future<bool> _startWebCheckout(double amount) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createCheckoutSession');
      final int amountCents = (amount * 100).toInt();

      final result = await callable.call(<String, dynamic>{
        'amount': amountCents,
        'currency': 'usd',
      });

      final data = result.data as Map<dynamic, dynamic>;
      final String? url = data['url'] as String?;
      
      if (url != null) {
        debugPrint("Redirecting to: $url");
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication); // webOnlyWindowName: '_self' works better for checkout
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Web Checkout Error: $e");
      return false;
    }
  }
}
