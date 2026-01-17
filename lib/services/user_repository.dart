import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of all users (Real-time updates)
  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Add a new user (for Testing/Seeding)
  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').add(user.toMap());
  }

  // Update Status (e.g. Ban/Unban)
  Future<void> updateUserStatus(String uid, String newStatus) async {
    await _firestore.collection('users').doc(uid).update({'status': newStatus});
  }
}
