import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
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
    _logoPositionAnimation =
        Tween<Offset>(
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

    // Start animations after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
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
      backgroundColor: const Color(0xFF161622),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Stack(
            children: [
              // Logo section with animation
              SlideTransition(
                position: _logoPositionAnimation,
                child: Center(
                  child: Image.asset(
                    'assets/image/logo.png',
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
                      const Text(
                        'Continue login with',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Glassmorphism container with google logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/image/glogo.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      'Developed by Oura team',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
