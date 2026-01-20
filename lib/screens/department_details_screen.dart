import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/stripe_service.dart';
import '../providers/auth_provider.dart';

// --- DATA MODELS ---

enum DepartmentType { aquatics, annex, cycling, yoga, childcare }

class DepartmentData {
  final String id;
  final String name;
  final DepartmentType type;
  final String status;
  final String statusDetail;
  final IconData icon;
  final Color color;
  final List<ClassSession> classes;
  final List<PaidService> paidServices;

  const DepartmentData({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.statusDetail,
    required this.icon,
    required this.color,
    required this.classes,
    required this.paidServices,
  });
}

class ClassSession {
  final String title;
  final String time;
  final String instructor;
  final int spotsLeft;

  const ClassSession(this.title, this.time, this.instructor, this.spotsLeft);
}

class PaidService {
  final String title;
  final String description;
  final double price;

  const PaidService(this.title, this.description, this.price);
}

// --- MOCK DATA REPOSITORY ---

final Map<DepartmentType, DepartmentData> mockDepartments = {
  DepartmentType.aquatics: DepartmentData(
    id: 'aquatics',
    name: 'Aquatics Center',
    type: DepartmentType.aquatics,
    status: 'Open',
    statusDetail: '3 Lanes Open',
    icon: Icons.pool,
    color: Colors.blue,
    classes: [
      ClassSession('Water Aerobics', '9:00 AM', 'Sarah J.', 5),
      ClassSession('Lap Swim', '11:00 AM', 'Open', 10),
      ClassSession('Kids Swim Lesson', '4:00 PM', 'Mike T.', 0),
    ],
    paidServices: [
      PaidService('Private Swim Coaching', '1-on-1 technique refinement (1 hr)', 45.00),
      PaidService('Lifeguard Certification', 'Weekend certification course', 150.00),
    ],
  ),
  DepartmentType.annex: DepartmentData(
    id: 'annex',
    name: 'The Annex',
    type: DepartmentType.annex,
    status: 'Busy',
    statusDetail: 'Next Class: 15min',
    icon: Icons.sports_mma,
    color: Colors.orange,
    classes: [
      ClassSession('Judo (Adults)', '6:00 PM', 'Sensei Ken', 8),
      ClassSession('Zumba', '7:30 PM', 'Maria R.', 15),
    ],
    paidServices: [
      PaidService('Private Dojo Rental', 'Rent the annex for 1 hr', 60.00),
    ],
  ),
  DepartmentType.cycling: DepartmentData(
    id: 'cycling',
    name: 'Cycle Studio',
    type: DepartmentType.cycling,
    status: 'Closed',
    statusDetail: 'Opens at 5:00 PM',
    icon: Icons.directions_bike,
    color: Colors.red,
    classes: [
      ClassSession('HIIT Ride', '5:30 PM', 'Coach Alex', 2),
      ClassSession('Endurance Ride', '6:45 PM', 'Coach Alex', 12),
    ],
    paidServices: [
      PaidService('FTP Test & Analysis', 'Professional power output test', 30.00),
    ],
  ),
  DepartmentType.yoga: DepartmentData(
    id: 'yoga',
    name: 'Upstairs Studio',
    type: DepartmentType.yoga,
    status: 'Open',
    statusDetail: 'Quiet Hours',
    icon: Icons.self_improvement,
    color: Colors.purple,
    classes: [
      ClassSession('Vinyasa Yoga', '10:00 AM', 'Luna L.', 4),
      ClassSession('BodyPump', '5:00 PM', 'FitTeam', 6),
    ],
    paidServices: [
      PaidService('Private Yoga Session', 'Personalized flow (1 hr)', 50.00),
    ],
  ),
  DepartmentType.childcare: DepartmentData(
    id: 'childcare',
    name: 'Kids Play & Care',
    type: DepartmentType.childcare,
    status: 'Open',
    statusDetail: 'Capacity: 80%',
    icon: Icons.child_care,
    color: Colors.pink,
    classes: [
      ClassSession('Open Play', 'Now - 8PM', 'Staff', 10),
      ClassSession('Arts & Crafts', '4:00 PM', 'Ms. Honey', 5),
    ],
    paidServices: [
      PaidService('Parents Night Out', 'Friday 6-10PM care + pizza', 25.00),
      PaidService('Birthday Party Pkg', '2 hr room rental + host', 200.00),
    ],
  ),
};


// --- SCREEN WIDGET ---

class DepartmentDetailsScreen extends ConsumerStatefulWidget {
  final DepartmentType departmentType;

  const DepartmentDetailsScreen({super.key, required this.departmentType});

  @override
  ConsumerState<DepartmentDetailsScreen> createState() => _DepartmentDetailsScreenState();
}

class _DepartmentDetailsScreenState extends ConsumerState<DepartmentDetailsScreen> {
  bool isSubscribed = false;

  @override
  Widget build(BuildContext context) {
    final data = mockDepartments[widget.departmentType]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        backgroundColor: data.color,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header & Status
            _buildStatusHeader(data),
            
            // 2. Notification Toggle
            _buildNotificationToggle(data),

            const Divider(),

            // 3. Today's Schedule
            _buildSectionTitle('Today\'s Schedule'),
            if (data.classes.isEmpty)
              const Padding(padding: EdgeInsets.all(16), child: Text('No classes scheduled today.')),
            ...data.classes.map((c) => _buildClassTile(c, data.color)),

            const Divider(),

            const Divider(),

            // 3.5 Private Training Calendar (New Feature)
            _buildSectionTitle('Trainer Availability'),
            _buildTrainingCalendar(context, data),

            const Divider(),

            // 4. Paid Services (1-on-1)
            _buildSectionTitle('Premium Services & Training'),
            ...data.paidServices.map((s) => _buildServiceTile(context, s, data.color)),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(DepartmentData data) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: data.color.withOpacity(0.1),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: data.color.withOpacity(0.2),
            child: Icon(data.icon, size: 36, color: data.color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.status, 
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: data.status == 'Open' ? Colors.green : (data.status == 'Closed' ? Colors.red : Colors.orange),
                  ),
                ),
                Text(
                  data.statusDetail, 
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(DepartmentData data) {
    return SwitchListTile(
      secondary: Icon(isSubscribed ? Icons.notifications_active : Icons.notifications_none, color: data.color),
      title: Text('Get ${data.name} Alerts'),
      subtitle: const Text('Closures, sub alerts, and special events.'),
      activeColor: data.color,
      value: isSubscribed,
      onChanged: (val) {
        setState(() => isSubscribed = val);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(val ? 'Subscribed to ${data.name}!' : 'Unsubscribed.')),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildClassTile(ClassSession session, Color color) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(session.time.split(' ')[0], style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(session.time.split(' ')[1], style: const TextStyle(fontSize: 12)),
        ],
      ),
      title: Text(session.title),
      subtitle: Text('Instructor: ${session.instructor}'),
      trailing: Chip(
        label: Text(session.spotsLeft > 0 ? '${session.spotsLeft} left' : 'Full'),
        backgroundColor: session.spotsLeft > 0 ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        labelStyle: TextStyle(color: session.spotsLeft > 0 ? color : Colors.grey),
      ),
    );
  }

  Widget _buildServiceTile(BuildContext context, PaidService service, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(side: BorderSide(color: color.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(service.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.description),
            const SizedBox(height: 4),
            Text('\$${service.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
          onPressed: () => _handleServiceBooking(context, service),
          child: const Text('Book'),
        ),
      ),
    );
  }

  Widget _buildTrainingCalendar(BuildContext context, DepartmentData data) {
    // Generate next 7 days
    final now = DateTime.now();
    final days = List.generate(7, (index) => now.add(Duration(days: index)));

    // Mock Availability Logic (e.g., availability on odd days)
    bool isAvailable(DateTime date) => date.day % 2 != 0;

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final available = isAvailable(date);
          final isSelected = false; // Could add state for selection

          return GestureDetector(
            onTap: () {
              if (available) {
                _showTimeSlots(context, date, data);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No availability on this day.')));
              }
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: available ? Colors.white : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: available ? data.color.withOpacity(0.5) : Colors.grey[300]!),
                boxShadow: available ? [BoxShadow(color: data.color.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : [],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getWeekday(date),
                          style: TextStyle(fontWeight: FontWeight.bold, color: available ? Colors.black87 : Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: available ? data.color : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (available)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green, // "Notification Bubble"
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getWeekday(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  void _showTimeSlots(BuildContext context, DateTime date, DepartmentData data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Slots for ${_getWeekday(date)} ${date.day}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['9:00 AM', '11:30 AM', '2:00 PM', '4:30 PM'].map((time) => ActionChip(
                label: Text(time),
                onPressed: () {
                  Navigator.pop(ctx);
                  // Trigger booking for this specific slot
                  _handleServiceBooking(context, PaidService('Training Session', '$time on ${_getWeekday(date)} ${date.day}', 45.00));
                },
              )).toList(),
            ),
             const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _handleServiceBooking(BuildContext context, PaidService service) async {
    final authState = ref.read(authProvider);

    // Show Confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Book ${service.title}?'),
        content: Text('Total: \$${service.price.toStringAsFixed(2)}\n\nYou will be redirected to payment.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm & Pay')),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing...')));
       
       final success = await StripeService.instance.makePayment(
          amount: service.price,
          userId: authState.userId ?? 'guest',
          userName: 'Member', 
       );

       if (context.mounted) {
         if (success) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Confirmed! Instructor notified.'), backgroundColor: Colors.green));
         } else {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Failed'), backgroundColor: Colors.red));
         }
       }
    }
  }
}
