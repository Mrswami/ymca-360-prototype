
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/ymca_theme.dart';
import '../services/auth_service.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;

  @override
  void initState() {
    super.initState();
    // Default Data (Mock)
    _nameController = TextEditingController(text: 'James Moreno');
    _emailController = TextEditingController(text: 'james.moreno@example.com');
    _phoneController = TextEditingController(text: '(512) 555-0199');
    _addressController = TextEditingController(text: '123 Austin Blvd, Apt 4B');
    _emergencyNameController = TextEditingController(text: 'Sarah Moreno');
    _emergencyPhoneController = TextEditingController(text: '(512) 555-0123');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      // Logic to Save
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated Successfully')));
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authProvider).role;
    String roleLabel = 'Member';
    Color roleColor = AppColors.ymcaBlue;
    
    if (role == UserRole.trainer) {
      roleLabel = 'Certified Trainer';
      roleColor = Colors.green;
    } else if (role == UserRole.manager) {
      roleLabel = 'Branch Manager';
      roleColor = Colors.black87;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const NetworkImage('https://ui-avatars.com/api/?name=James+Moreno&size=200'),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(roleLabel, style: TextStyle(color: roleColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Contact Info
            _buildSectionHeader('Contact Information'),
            _buildTextField('Full Name', _nameController, Icons.person),
            _buildTextField('Email', _emailController, Icons.email),
            _buildTextField('Phone', _phoneController, Icons.phone),
            _buildTextField('Address', _addressController, Icons.home),

            const SizedBox(height: 24),

            // Emergency Contact (Important for Gyms)
            _buildSectionHeader('Emergency Contact'),
            _buildTextField('Contact Name', _emergencyNameController, Icons.person_outline),
            _buildTextField('Contact Phone', _emergencyPhoneController, Icons.phone_android),

            // Role Specific Section
            if (role == UserRole.manager) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('Staff Settings'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.security, color: Colors.grey),
                title: const Text('Badge ID'),
                subtitle: const Text('MGR-8892'),
                trailing: const Icon(Icons.copy, size: 16),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ymcaBlue)),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: Colors.grey.shade300)),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: _isEditing,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: const OutlineInputBorder(),
          filled: !_isEditing,
          fillColor: Colors.grey.shade50,
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200)),
        ),
      ),
    );
  }
}
