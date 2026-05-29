import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';

class AppShimmer extends StatelessWidget {
  final int itemCount;
  final double height;

  const AppShimmer({
    super.key,
    this.itemCount = 6,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class AppShimmerGrid extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final double aspectRatio;

  const AppShimmerGrid({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.aspectRatio = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: aspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
