import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() => GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.home,
      errorBuilder: (context, state) => const _NotFoundPage(),
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => _buildPage('Login'),
        ),
        GoRoute(
          path: AppRoutes.signUp,
          builder: (context, state) => _buildPage('Sign Up'),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => _AppShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => _buildPage('Home'),
            ),
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => _buildPage('Settings'),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => _buildPage('Profile'),
            ),
          ],
        ),
      ],
    );

Widget _buildPage(String title) => Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );

class _AppShell extends StatelessWidget {
  final Widget child;

  const _AppShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Page not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
