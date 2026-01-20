
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of users with optional limit
  Stream<List<UserModel>> getUsers({int limit = 20}) {
    return _firestore
        .collection('users')
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
  
  // Fetch paginated users (One-time fetch, not stream)
  Future<List<UserModel>> fetchUsers({int limit = 20, DocumentSnapshot? startAfter}) async {
    Query query = _firestore.collection('users').orderBy('firstName').limit(limit);
    
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
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
