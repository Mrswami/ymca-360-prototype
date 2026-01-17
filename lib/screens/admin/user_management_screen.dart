import 'package:flutter/material.dart';
import '../../services/user_repository.dart';
import '../../data/user_model.dart';
import '../../theme/ymca_theme.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepo = UserRepository();

    return Scaffold(
      appBar: AppBar(title: const Text('Member Database')),
      body: StreamBuilder<List<UserModel>>(
        stream: userRepo.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            child: PaginatedDataTable(
              header: const Text('All Registered Users'),
              rowsPerPage: 10,
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              source: _UserDataSource(users, context),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add "Create User" dialog
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feature coming in Phase 3')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No users found in Database.', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Create a document in Firestore Console > "users" to see it here.'),
        ],
      ),
    );
  }
}

class _UserDataSource extends DataTableSource {
  final List<UserModel> users;
  final BuildContext context;
  _UserDataSource(this.users, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) return null;
    final user = users[index];
    return DataRow(cells: [
      DataCell(Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(user.email)),
      DataCell(_buildRoleBadge(user.role)),
      DataCell(_buildStatusChip(user.status)),
      DataCell(IconButton(
        icon: const Icon(Icons.edit, color: Colors.blue),
        onPressed: () => _showEditDialog(context, user),
      )),
    ]);
  }

  Widget _buildRoleBadge(String role) {
    Color color = Colors.grey;
    if (role == 'manager') color = Colors.purple;
    if (role == 'trainer') color = Colors.orange;
    return Text(role.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold));
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.green;
    if (status == 'Past Due') color = Colors.red;
    if (status == 'Inactive') color = Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${user.firstName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('Set Active'), onTap: () {
              UserRepository().updateUserStatus(user.uid, 'Active');
              Navigator.pop(ctx);
            }),
             ListTile(title: const Text('Set Past Due (Ban)'), onTap: () {
              UserRepository().updateUserStatus(user.uid, 'Past Due');
              Navigator.pop(ctx);
            }),
          ],
        ),
      ),
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => users.length;
  @override
  int get selectedRowCount => 0;
}
