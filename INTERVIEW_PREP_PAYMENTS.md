### Payment Architecture - The "Hybrid" Approach
**Question:** "How did you handle payments across Mobile and Web?"

**Answer:**
"I architected an adaptive solution to handle platform fragmentation:
1.  **Mobile (iOS/Android):** I implemented the native `PaymentSheet`. This keeps the user inside the app and provides the most premium experience (Apple Pay / saved cards).
2.  **Web:** Since native SDKs don't work in the browser, I built a logic branch that seamlessly redirects the user to a **Stripe Checkout Session**.
3.  **Result:** The unified `StripeService` class abstracts this complexity away from the UI. The front-end widget just calls `makePayment()`, and the service decides the correct strategy (Sheet vs Redirect) at runtime."
