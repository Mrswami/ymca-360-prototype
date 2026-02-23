const functions = require("firebase-functions"); // Redeploy trigger v2
const admin = require("firebase-admin");

let stripe;
try {
  // Check if stripe config exists before requiring
  if (functions.config().stripe && functions.config().stripe.secret) {
    stripe = require("stripe")(functions.config().stripe.secret);
  } else {
    console.warn("Stripe config missing (functions.config().stripe.secret). Payments disabled.");
  }
} catch (e) {
  console.warn("Error initializing Stripe:", e);
}

admin.initializeApp();

/**
 * Creates a Stripe Payment Intent for a One-Time Charge.
 * Call this from the Flutter app to get a client_secret.
 */
exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  // 1. Validation
  // if (!context.auth) {
  //   throw new functions.https.HttpsError('failed-precondition', 'The function must be called while authenticated.');
  // }

  // 1. Validation
  console.log("Received payment request:", data);
  const amount = data.amount; // e.g. 1000 for $10.00
  const currency = data.currency || 'usd';

  if (!amount) {
    throw new functions.https.HttpsError('invalid-argument', 'The function must be called with an "amount" argument.');
  }

  // 2. Create Intent
  if (!stripe) {
    throw new functions.https.HttpsError('failed-precondition', 'Stripe payments are not configured on the server.');
  }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: currency,
      automatic_payment_methods: { enabled: true },
      metadata: { integration_check: 'accept_a_payment' },
    });

    // 3. Return Client Secret to App
    return {
      clientSecret: paymentIntent.client_secret,
    };
  } catch (error) {
    console.error("Stripe Error:", error);
    throw new functions.https.HttpsError('unknown', error.message, error);
  }
});

exports.createCheckoutSession = functions.https.onCall(async (data, context) => {
  const amount = data.amount;
  const currency = data.currency || 'usd';
  const successUrl = data.successUrl || 'http://localhost:5000/success'; // Default for local testing
  const cancelUrl = data.cancelUrl || 'http://localhost:5000/cancel';
  const customerEmail = data.customerEmail || 'member@example.com'; // Pre-fill email for demo

  if (!stripe) {
    throw new functions.https.HttpsError('failed-precondition', 'Stripe payments are not configured on the server.');
  }

  try {
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      customer_email: customerEmail, // AUTOFILL: Pre-fills the email field
      line_items: [{
        price_data: {
          currency: currency,
          product_data: {
            name: 'YMCA Day Pass ($10)',
          },
          unit_amount: amount,
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: successUrl,
      cancel_url: cancelUrl,
    });

    return {
      sessionId: session.id,
      url: session.url
    };
  } catch (error) {
    console.error("Stripe Checkout Error:", error);
    throw new functions.https.HttpsError('unknown', error.message, error);
  }
});

/**
 * Send Push Notification to a topic
 * Called from the Admin Panel
 */
exports.sendNotification = functions.https.onCall(async (data, context) => {
  // Verify the user is authenticated (optional but recommended)
  // if (!context.auth) {
  //   throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  // }

  const { title, body, type, topic } = data;

  // Validation
  if (!title || !body || !topic) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required fields: title, body, or topic');
  }

  // Build notification payload
  const message = {
    notification: {
      title: title,
      body: body,
    },
    data: {
      type: type || 'general',
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
    },
    topic: topic,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent notification:', response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('Error sending notification:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification', error);
  }
});
