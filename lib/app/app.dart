/// App shell widget with MaterialApp and GoRouter configuration.
///
/// MiniMax fills in: GoRouter route definitions, theme provider,
/// Riverpod ProviderScope wrapping.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_reminder_app/features/medication/presentation/pages/medication_list_page.dart';
import 'package:smart_reminder_app/features/medication/presentation/pages/add_medication_page.dart';
import 'package:smart_reminder_app/features/medication/presentation/pages/adherence_dashboard_page.dart';
import 'package:smart_reminder_app/features/cycle/presentation/pages/cycle_log_page.dart';
import 'package:smart_reminder_app/features/cycle/presentation/pages/cycle_calendar_page.dart';
import 'package:smart_reminder_app/features/insights/presentation/pages/insights_page.dart';
import 'package:smart_reminder_app/features/test_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/test', // Change to '/medications' for production
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/test',
          builder: (context, state) => const HardwareTestScreen(), 
        ),
        GoRoute(
          path: '/medications',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MedicationListPage(),
          ),
          routes: [
            GoRoute(
              path: 'add',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const AddMedicationPage(),
            ),
            GoRoute(
              path: 'adherence',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const AdherenceDashboardPage(),
            ),
          ],
        ),
        GoRoute(
          path: '/cycle',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CycleLogPage(),
          ),
          routes: [
            GoRoute(
              path: 'calendar',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const CycleCalendarPage(),
            ),
          ],
        ),
        GoRoute(
          path: '/insights',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InsightsPage(),
          ),
        ),
      ],
    ),
  ],
);

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'test',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'Medications',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Cycle',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/medications')) return 0;
    if (location.startsWith('/cycle')) return 1;
    if (location.startsWith('/insights')) return 2;
    if (location.startsWith('/test')) return 3; // For testing purposes
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/medications');
        break;
      case 1:
        context.go('/cycle');
        break;
      case 2:
        context.go('/insights');
        break;
      case 3:
        context.go('/test'); // For testing purposes
        break;
    }
  }
}

class SmartReminderApp extends StatelessWidget {
  const SmartReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Health Reminder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
