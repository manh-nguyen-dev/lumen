import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumen/config/routes/routes.dart';
import 'package:lumen/core/theme/dimensions.dart';
import 'package:lumen/core/theme/text_styles.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: AppTextStyles.displayLarge(context).copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'Page not found',
              style: AppTextStyles.headlineMedium(context),
            ),
            const SizedBox(height: AppDimensions.xl),
            ElevatedButton.icon(
              onPressed: () => context.go(Routes.home),
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.xl,
                  vertical: AppDimensions.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}