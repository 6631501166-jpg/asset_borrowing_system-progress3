import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();

  bool _obscurePwd = true;
  bool _obscureCfm = true;
  bool _isLoading = false;

  // === Colors copied from login ===
  static const Color _bg = Color(0xFF0C1851); // page background
  static const Color _boxFill = Color(
    0xFF081038,
  ); // input box fill (from login)
  static const Color _ctaFill = Color(
    0xFF1D2965,
  ); // login button color (reuse here)

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading indicator
    setState(() => _isLoading = true);

    try {
      // Call the API
      final result = await ApiService.register(
        email: _email.text.trim(),
        password: _password.text,
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        username: _username.text.trim(),
        phoneNumber: _phone.text.trim().isNotEmpty ? _phone.text.trim() : null,
      );

      // Hide loading indicator
      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success'] == true) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login screen
        Navigator.pushReplacementNamed(context, '/student-login');
      } else {
        // Registration failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      setState(() => _isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // EXACT same box style as login
  BoxDecoration _boxDecoration() => BoxDecoration(
    color: _boxFill,
    border: Border.all(color: Colors.white.withOpacity(0.3)),
    borderRadius: BorderRadius.circular(8),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Logo
                    const Icon(Icons.layers, color: Colors.white, size: 48),

                    const SizedBox(height: 22),
                    const Text(
                      'Please fill your account Information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13.5,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // First & Last name (side-by-side)
                    Row(
                      children: [
                        Expanded(
                          child: _boxedField(
                            controller: _firstName,
                            hintText: 'First Name',
                            prefixIcon: Icons.badge_outlined,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _boxedField(
                            controller: _lastName,
                            hintText: 'Last Name',
                            prefixIcon: Icons.badge_outlined,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _boxedField(
                      controller: _username,
                      hintText: 'Username',
                      prefixIcon: Icons.person_outline,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    _boxedField(
                      controller: _email,
                      hintText: 'Email Address',
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
                        return ok ? null : 'Invalid email';
                      },
                    ),
                    const SizedBox(height: 12),

                    _boxedField(
                      controller: _password,
                      hintText: 'Password',
                      prefixIcon: Icons.vpn_key_outlined,
                      isPassword: true,
                      obscureText: _obscurePwd,
                      onToggleObscure: () =>
                          setState(() => _obscurePwd = !_obscurePwd),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _boxedField(
                      controller: _confirm,
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.vpn_key_outlined,
                      isPassword: true,
                      obscureText: _obscureCfm,
                      onToggleObscure: () =>
                          setState(() => _obscureCfm = !_obscureCfm),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (v != _password.text)
                          return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _boxedField(
                      controller: _phone,
                      hintText: 'Phone Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      prefixText: '(+66)  ',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),

                    const SizedBox(height: 26),

                    // REGISTER (same feel as login button but full-width)
                    SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: _isLoading ? null : _submit,
                        child: Ink(
                          decoration: _boxDecoration().copyWith(
                            color: _isLoading
                                ? _ctaFill.withOpacity(0.6)
                                : _ctaFill,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Cancel
                    TextButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            '/student-login',
                          );
                        }
                      },
                      child: const Text(
                        'Cancel Registration',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// EXACT same input box visual spec as login.
  Widget _boxedField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    String? prefixText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      decoration: _boxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: Icon(prefixIcon, color: Colors.white70, size: 20),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              obscureText: isPassword ? obscureText : false,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0x99FFFFFF),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w300,
                ),
                prefixText: prefixText,
                prefixStyle: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                // eye icon for passwords (right side)
                suffixIcon: isPassword
                    ? IconButton(
                        onPressed: onToggleObscure,
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
