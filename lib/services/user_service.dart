import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncUser(User user, UserRole role) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      // Create new user profile
      await userRef.set({
        'uid': user.uid,
        'email': user.email, // Might be null for anonymous
        'role': role.name,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'duprId': null, // For Pickleball integration
        'displayName': user.displayName ?? 'YMCA Member',
      });
    } else {
      // Update existing user (e.g. last login)
      await userRef.update({
        'lastLogin': FieldValue.serverTimestamp(),
        // We might want to sync role from local if it's an upgrade, 
        // but typically Firestore is source of truth.
        // For now, we respect the requested role for the demo.
        'role': role.name, 
      });
    }
  }

  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()?['role'] as String?;
    }
    return null;
  }
}
