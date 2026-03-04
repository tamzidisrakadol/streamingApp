import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_app/Profile/OnBoardProfile.dart';
import 'package:streaming_app/config/di/injection_container.dart';
import 'package:streaming_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:streaming_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:streaming_app/features/authentication/presentation/pages/login_page.dart';
import 'package:streaming_app/Splash/SplashScreen.dart';

/// Route names
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String onBoard = '/onboard';
  static const String home = '/home';
  static const String streamViewer = '/stream-viewer';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// App router configuration
class AppRouter {
  AppRouter._();

  /// Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const Splashscreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthBloc>()..add(const CheckAuthStatus()),
            child: const LoginPage(),
          ),
        );

      case AppRoutes.onBoard:
        return MaterialPageRoute(
          builder: (_) => const OnBoardProfile(),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // TODO: Replace with HomePage
        );

      case AppRoutes.streamViewer:
        // final streamId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // TODO: Replace with StreamViewerPage
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // TODO: Replace with ProfilePage
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(), // TODO: Replace with SettingsPage
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Navigate to a route
  static Future<T?> push<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Replace current route
  static Future<T?> pushReplacement<T, TO>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Push and remove all previous routes
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop current route
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }
}
