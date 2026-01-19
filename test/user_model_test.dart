import 'package:flutter_test/flutter_test.dart';
import 'package:example_app/data/user_model.dart'; // Ensure this import matches your package name (which is 'example_app' in pubspec.yaml)

void main() {
  group('UserModel', () {
    test('should correctly create UserModel from Map', () {
      final data = {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john.doe@example.com',
        'role': 'member',
        'status': 'Active',
        'joinedAt': '2023-01-01T00:00:00.000',
        'homeBranch': 'Downtown YMCA',
      };
      const uid = 'user123';

      final user = UserModel.fromMap(data, uid);

      expect(user.uid, uid);
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.role, 'member');
      expect(user.status, 'Active');
      expect(user.homeBranch, 'Downtown YMCA');
      expect(user.fullName, 'John Doe');
    });

    test('should correctly convert UserModel to Map', () {
      final user = UserModel(
        uid: 'user123',
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane.smith@example.com',
        role: 'trainer',
        status: 'Inactive',
        joinedAt: DateTime(2023, 1, 1),
        homeBranch: 'North Austin YMCA',
      );

      final map = user.toMap();

      expect(map['firstName'], 'Jane');
      expect(map['lastName'], 'Smith');
      expect(map['email'], 'jane.smith@example.com');
      expect(map['role'], 'trainer');
      expect(map['status'], 'Inactive');
      expect(map['homeBranch'], 'North Austin YMCA');
    });

    test('should handle missing fields with default values', () {
      final data = <String, dynamic>{}; // Empty map
      const uid = 'user123';

      final user = UserModel.fromMap(data, uid);

      expect(user.uid, uid);
      expect(user.firstName, ''); // Default string
      expect(user.role, 'member'); // Default role
      expect(user.status, 'Active'); // Default status
    });
  });
}
