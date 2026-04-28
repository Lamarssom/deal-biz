import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/customer/home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Customer Home Feed\n(Deals near you - Coming soon)')),
        ),
      ),
      GoRoute(
        path: '/merchant/dashboard',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Merchant Dashboard\n(Coming soon)')),
        ),
      ),
    ],
  );
});