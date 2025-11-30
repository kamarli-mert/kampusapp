import 'package:flutter/material.dart';
import 'home_page.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _classController = TextEditingController();
  final _schoolNumberController = TextEditingController();
  final _schoolEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    // Mock register - navigate to Home
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kayıt Ol',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_nameController, 'İsim', Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField(_surnameController, 'Soyisim', Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField(_departmentController, 'Bölüm', Icons.school_outlined),
              const SizedBox(height: 16),
              _buildTextField(_classController, 'Sınıf', Icons.class_outlined),
              const SizedBox(height: 16),
              _buildTextField(_schoolNumberController, 'Okul Numarası', Icons.badge_outlined),
              const SizedBox(height: 16),
              _buildTextField(_schoolEmailController, 'Okul E-postası', Icons.email_outlined),
              const SizedBox(height: 16),
              _buildTextField(_passwordController, 'Şifre', Icons.lock_outline, isPassword: true),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kayıt Ol',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

