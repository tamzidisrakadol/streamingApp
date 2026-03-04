import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_app/config/routes/app_router.dart';
import 'package:streaming_app/core/constants/app_colors.dart';
import 'package:streaming_app/core/constants/app_strings.dart';
import 'package:streaming_app/core/constants/asset_paths.dart';
import 'package:streaming_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:streaming_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:streaming_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:streaming_app/features/authentication/presentation/widgets/google_sign_in_button.dart';

/// Login page with animated splash and Google Sign-In
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loginSectionAnimationController;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<double> _loginSectionOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller - for moving logo to top
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Login section animation controller - for fade in
    _loginSectionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Logo position animation - moves from center to top
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.2),
    ).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Login section opacity animation
    _loginSectionOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loginSectionAnimationController,
        curve: Curves.easeIn,
      ),
    );

    // Start animations after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _logoAnimationController.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _loginSectionAnimationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loginSectionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                // Existing user - Navigate to home page
                print('✅ LoginPage: Navigating to home (existing user)');
                AppRouter.pushAndRemoveUntil(context, AppRoutes.home);
              } else if (state is AuthNeedsOnboarding) {
                // New user - Navigate to onboarding (when implemented)
                print('🆕 LoginPage: New user needs onboarding');
                // TODO: Navigate to onboarding screen when implemented
                // AppRouter.pushAndRemoveUntil(context, AppRoutes.onboarding);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New user! Onboarding screen coming soon...'),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 3),
                  ),
                );
              } else if (state is AuthError) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  // Logo section with animation
                  SlideTransition(
                    position: _logoPositionAnimation,
                    child: Center(
                      child: Image.asset(
                        AssetPaths.logo,
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ),

                  // Login section centered on screen with fade in animation
                  Center(
                    child: FadeTransition(
                      opacity: _loginSectionOpacityAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.continueLoginWith,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 24),

                          // Google Sign-In button
                          GoogleSignInButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                          const LoginWithGoogleRequested(),
                                        );
                                  },
                            isLoading: state is AuthLoading,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Loading indicator
                  if (state is AuthLoading)
                    Container(
                      color: AppColors.overlay,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                  // Footer text at bottom center
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.developedBy,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.appVersion,
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
