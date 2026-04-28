import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('SD', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              Text(AppConstants.appName, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              Text('Sign Up', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 32),

              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
              const SizedBox(height: 16),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)), obscureText: true),
              const SizedBox(height: 16),
              TextField(controller: _confirmPasswordController, decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock)), obscureText: true),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/welcome'),
                child: const Text('Sign Up'),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  TextButton(onPressed: () => context.go('/login'), child: const Text('Login')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}