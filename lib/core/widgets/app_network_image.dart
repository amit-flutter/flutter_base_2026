import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppRadius.md,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => Container(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
        ),
        errorWidget: (_, _, _) => Container(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
        onBackgroundImageError: (_, _) {},
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        _initials,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.4,
        ),
      ),
    );
  }

  String get _initials {
    if (initials != null && initials!.isNotEmpty) return initials!;
    return '?';
  }
}
