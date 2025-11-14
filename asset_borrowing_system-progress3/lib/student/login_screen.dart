// lib/screens/student_login_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;

  String? _usernameError; // outside-the-box validator message
  String? _passwordError; // outside-the-box validator message

  static const _bg = Color(0xFF0C1851);
  static const _boxFill = Color(0xFF081038);

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      if (_usernameError != null &&
          _usernameController.text.trim().isNotEmpty) {
        setState(() => _usernameError = null);
      }
    });
    _passwordController.addListener(() {
      if (_passwordError != null && _passwordController.text.isNotEmpty) {
        setState(() => _passwordError = null);
      }
    });
  }

  @override
  void dispose() {
    _usernameController
      ..text = ''
      ..dispose();
    _passwordController
      ..text = ''
      ..dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState == null) return;

    String? userErr;
    String? passErr;

    if (_usernameController.text.trim().isEmpty) {
      userErr = 'Please enter your email or username';
    }
    if (_passwordController.text.isEmpty) {
      passErr = 'Please enter your password';
    }

    setState(() {
      _usernameError = userErr;
      _passwordError = passErr;
    });

    if (userErr != null || passErr != null) return;

    // Show loading state
    setState(() => _isLoading = true);

    try {
      final credential = _usernameController.text.trim();
      
      // Determine if the credential is an email, username, or UID
      // Email contains '@', UID is all digits, otherwise it's username
      final bool isEmail = credential.contains('@');
      final bool isUid = RegExp(r'^\d+$').hasMatch(credential);
      
      // Call login API with the appropriate field
      final result = await ApiService.login(
        email: isEmail ? credential : null,
        username: (!isEmail && !isUid) ? credential : null,
        uid: isUid ? credential : null,
        password: _passwordController.text,
      );

      // Hide loading state
      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success'] == true) {
        // Login successful
        final userData = result['data'];
        
        // Debug: Print entire API response
        print('🔍 Login API Response: $userData');
        
        // Extract user information from API response
        // API may return 'user_id' OR 'uid' - handle both cases
        final int userId = (userData['user_id'] ?? userData['uid'] ?? 0) as int;
        final String uid = userData['uid']?.toString() ?? '';
        final String username = userData['username'] ?? '';
        final String email = userData['email'] ?? '';
        final String firstName = userData['first_name'] ?? '';
        final String lastName = userData['last_name'] ?? '';
        final String role = userData['role'] ?? '';
        final String? token = userData['token'];
        
        print('🔍 Extracted userId: $userId (type: ${userId.runtimeType})');
        print('🔍 userData[user_id]: ${userData['user_id']}');
        print('🔍 userData[uid]: ${userData['uid']}');
        
        // Validate that we got a valid user ID
        if (userId == 0) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Login error: Invalid user ID from server. Check backend API.'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
          return;
        }
        
        // Save session to local storage
        await SessionManager.saveSession(
          userId: userId,
          uid: uid,
          username: username,
          email: email,
          firstName: firstName,
          lastName: lastName,
          role: role,
          token: token,
        );
        
        // Show welcome alert dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0E1939),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Welcome back, $firstName $lastName!\nRole: $role\nLogin successful.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF1D2965),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );

        if (!mounted) return;

        // Navigate based on user role
        // The API returns role field which could be 'student', 'lecturer', or 'staff'
        if (role.toLowerCase() == 'student') {
          Navigator.pushReplacementNamed(context, '/student-assets');
        } else if (role.toLowerCase() == 'lecturer') {
          Navigator.pushReplacementNamed(context, '/lecturer-assets');
        } else if (role.toLowerCase() == 'staff') {
          Navigator.pushReplacementNamed(context, '/staff-assets');
        } else {
          // Default fallback
          Navigator.pushReplacementNamed(context, '/student-assets');
        }
      } else {
        // Login failed - show error
        // API returns plain text error messages: "Wrong username" or "Wrong password"
        final errorMessage = result['message'] ?? 'Login failed';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      setState(() => _isLoading = false);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  BoxDecoration _boxDecoration(BuildContext context) => BoxDecoration(
        color: _boxFill,
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 36),
                      const Icon(Icons.layers, color: Colors.white, size: 48),

                      const SizedBox(height: 20),
                      const Text(
                        'Welcome to the Assets Borrowing System',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Username
                      SizedBox(
                        width: 300,
                        child: _boxedField(
                          context: context,
                          controller: _usernameController,
                          hintText: 'Enter your ID, username or email address',
                          prefixIcon: Icons.credit_card_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [
                            AutofillHints.username,
                            AutofillHints.email,
                          ],
                          validator: null,
                        ),
                      ),
                      if (_usernameError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _usernameError!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Password
                      SizedBox(
                        width: 300,
                        child: _boxedField(
                          context: context,
                          controller: _passwordController,
                          hintText: 'Enter Password',
                          prefixIcon: Icons.key_outlined,
                          obscureText: _obscurePassword,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                          autofillHints: const [AutofillHints.password],
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                              color: Colors.white70,
                            ),
                          ),
                          validator: null,
                        ),
                      ),
                      if (_passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _passwordError!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 30),

                      // Login button
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _isLoading ? null : _handleLogin,
                        child: Ink(
                          width: 120,
                          decoration: _boxDecoration(context).copyWith(
                            color: _isLoading 
                                ? const Color(0xFF1D2965).withOpacity(0.6)
                                : const Color(0xFF1D2965),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔗 Go to register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/student-register'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Text field wrapped in a Setting-style box.
  Widget _boxedField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<String>? autofillHints,
    FocusNode? focusNode,
    void Function(String)? onFieldSubmitted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _boxDecoration(context),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: Icon(prefixIcon, color: Colors.white70, size: 20),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
              autofillHints: autofillHints,
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0x99FFFFFF),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          if (suffixIcon != null) suffixIcon,
        ],
      ),
    );
  }
}
