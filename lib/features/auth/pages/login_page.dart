import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../icons/lucide_adapter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // White background
      body: SafeArea(
        child: Column(
          children: [
            // Top section (65-70% of screen height)
            Expanded(
              flex: 7,
              child: Center(
                child: Text(
                  'Build X',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 40 : 36,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000), // Black color
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            
            // Bottom sheet (35% of screen height)
            Container(
              width: double.infinity,
              height: screenHeight * 0.35,
              decoration: const BoxDecoration(
                color: Color(0xFF0A0A0A), // Very dark gray/black
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  children: [
                    // Continue with Google button
                    _buildButton(
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      backgroundColor: const Color(0xFFFFFFFF),
                      textColor: const Color(0xFF000000),
                      text: 'Continue with Google',
                      icon: _buildGoogleIcon(),
                    ),
                    
                    const SizedBox(height: 14),
                    
                    // Sign up button
                    _buildButton(
                      onPressed: _isLoading ? null : _showSignUpDialog,
                      backgroundColor: const Color(0xFFD6D6D6),
                      textColor: const Color(0xFF000000),
                      text: 'Sign up',
                    ),
                    
                    const SizedBox(height: 14),
                    
                    // Log in button
                    _buildButton(
                      onPressed: _isLoading ? null : _showLoginDialog,
                      backgroundColor: const Color(0xFF000000),
                      textColor: const Color(0xFFFFFFFF),
                      text: 'Log in',
                      borderColor: const Color(0xFF333333),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
    required String text,
    Widget? icon,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
            side: borderColor != null 
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: _isLoading && text == 'Continue with Google'
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon,
                    const SizedBox(width: 12),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://developers.google.com/identity/images/g-logo.png',
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        // User signed in successfully - the StreamBuilder in main.dart will handle navigation
        // No need to manually navigate as the auth state change will trigger automatic navigation
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSignUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up'),
        content: const Text('Sign up functionality will be implemented soon. For now, please use Google Sign In.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log In'),
        content: const Text('Email/password login will be implemented soon. For now, please use Google Sign In.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}