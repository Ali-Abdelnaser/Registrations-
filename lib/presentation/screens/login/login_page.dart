import 'package:flutter/material.dart';
import 'package:registration/core/constants/app_colors.dart';
import 'package:registration/data/repositories/attendee_repository.dart';
import 'package:registration/presentation/screens/Bottom%20App%20Bar/Batton_aoo_bar.dart';
import 'package:registration/presentation/widgets/navigator.dart';
import 'package:registration/presentation/widgets/password_TextField.dart';
import 'package:registration/presentation/widgets/snakbar.dart';
import 'package:registration/presentation/widgets/text-filed.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = AuthRepository();
      final user = await authRepo.signIn(_email, _password);

      if (user != null) {
        // ✅ نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnakBar(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            text: "Login successful",
            textColor: AppColors.Blue,
          ),
        );
        // تروح للـ Home أو Dashboard
        AppNavigator.fade(context, ModernBottomNav());
      } else {
        // ❌ لو رجع null
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnakBar(
            icon: Icons.error,
            iconColor: Colors.red,
            text: "Invalid email or password",
            textColor: AppColors.red,
          ),
        );
      }
    } catch (e) {
      // ❌ فشل
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnakBar(
          icon: Icons.warning_amber,
          iconColor: Colors.orange,
          text: "Login failed: $e",
          textColor: Colors.orange,
        ),
      );}

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية غامقة عشان التيكست أبيض
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 50),

              // ✅ الصورة فوق
              Center(child: Image.asset("assets/img/login.png", height: 300)),

              const SizedBox(height: 40),

              // ✅ Email field
              CustomTextField(
                icon: Icons.email_outlined,
                hint: "Email",
                onChanged: (val) => _email = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },

                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // ✅ Password field
              PasswordTextField(
                icon: "assets/icons/lock.svg",
                hint: "Enter your password",
                onChanged: (val) => _password = val,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // ✅ Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.Blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
