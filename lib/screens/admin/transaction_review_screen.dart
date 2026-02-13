import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionReviewScreen extends StatelessWidget {
  const TransactionReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Batch (Transactions)')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            // .orderBy('timestamp', descending: true) // Commented out to avoid Index requirement for now
            .limit(50)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
              final status = data['status'] as String? ?? 'unknown';
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
              final userName = data['userName'] as String? ?? 'Unknown User';
              final type = data['type'] as String? ?? 'Payment';

              Color statusColor = Colors.grey;
              IconData statusIcon = Icons.help_outline;

              if (status == 'succeeded') {
                statusColor = Colors.green;
                statusIcon = Icons.check_circle;
              } else if (status == 'pending_redirect') {
                statusColor = Colors.orange;
                statusIcon = Icons.open_in_browser;
              } else if (status == 'failed') {
                statusColor = Colors.red;
                statusIcon = Icons.error;
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor.withOpacity(0.1),
                    child: Icon(statusIcon, color: statusColor),
                  ),
                  title: Text('\$${amount.toStringAsFixed(2)} - $type'),
                  subtitle: Text('$userName\n${timestamp != null ? DateFormat('MMM d, h:mm a').format(timestamp) : 'Pending...'}'),
                  isThreeLine: true,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase().replaceAll('_', ' '),
                      style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
