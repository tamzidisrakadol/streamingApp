import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:streaming_app/core/constants/app_colors.dart';
import 'package:streaming_app/core/constants/asset_paths.dart';

/// Google Sign-In button with glassmorphism effect
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.glassMorphismBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.glassMorphismBorder,
                width: 1.5,
              ),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Image.asset(
                      AssetPaths.googleLogo,
                      width: 40,
                      height: 40,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
