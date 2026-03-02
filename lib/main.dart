import 'package:flutter/material.dart';
import 'package:streaming_app/Service/firebase/firebase_initializer.dart';
import 'package:streaming_app/config/di/injection_container.dart';
import 'package:streaming_app/config/routes/app_router.dart';
import 'package:streaming_app/config/theme/app_theme.dart';
import 'package:streaming_app/core/constants/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseInitializer.initialize();

  // Initialize dependency injection (includes Hive initialization)
  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}


