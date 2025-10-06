import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:testing/wrapper.dart';
import 'package:testing/login.dart'; // Import the Login page

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool isLoading = false;
  bool isResending = false;

  @override
  void initState() {
    super.initState();
    sendVerifyLink();
  }

  Future<void> sendVerifyLink() async {
    setState(() {
      isResending = true;
    });
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.sendEmailVerification();
        Get.snackbar(
          "Link Sent",
          "A verification link has been sent to ${user.email}.",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.white.withOpacity(0.9),
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (error) {
        Get.snackbar(
          "Error",
          error.toString(),
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "No user is currently signed in.",
        margin: EdgeInsets.all(20),
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    setState(() {
      isResending = false;
    });
  }

  Future<void> reload() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          Get.snackbar(
            "Success",
            "Email verified successfully!",
            margin: EdgeInsets.all(20),
            backgroundColor: Colors.white.withOpacity(0.9),
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offAll(() => Wrapper());
        } else {
          Get.snackbar(
            "Not Verified",
            "Your email is not yet verified. Please check your email.",
            margin: EdgeInsets.all(20),
            backgroundColor: Colors.redAccent.withOpacity(0.9),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "No user is currently signed in.",
          margin: EdgeInsets.all(20),
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        error.toString(),
        margin: EdgeInsets.all(20),
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> backToLogin() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => Login());
    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to sign out: $error",
        margin: EdgeInsets.all(20),
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),
          )
        : Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.purple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 80,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Verify Your Email",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "A verification link has been sent to your email. Please check your inbox (and spam/junk folder) to verify your account.",
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: reload,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            "I've Verified My Email",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: isResending ? null : sendVerifyLink,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: isResending
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black87,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Resend Verification Email",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: backToLogin,
                          child: Text(
                            "Back to Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
