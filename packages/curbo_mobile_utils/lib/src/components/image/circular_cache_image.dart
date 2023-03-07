import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularCacheImage extends StatelessWidget {
  CircularCacheImage({
    Key? key,
    required this.url,
    this.onTap,
    this.width = 60,
    this.height = 60,
    this.cacheKey,
    this.fit = BoxFit.cover,
    this.maxHeightDiskCache = 60 * 3,
    this.maxWidthDiskCache = 60 * 3,
    required this.placeholder,
    required this.errorWidget,
  }) : super(key: key);

  final String url;
  final double width;
  final double height;
  final Function()? onTap;
  final String? cacheKey;
  final BoxFit fit;
  final int maxWidthDiskCache;
  final int maxHeightDiskCache;
  final Widget placeholder;
  final Widget errorWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ClipOval(
        child: Material(
          shape: CircleBorder(),
          child: InkWell(
            onTap: onTap,
            child: url.isNotEmpty
                ? CachedNetworkImage(
                    cacheKey: cacheKey,
                    fit: fit,
                    maxHeightDiskCache: maxHeightDiskCache,
                    maxWidthDiskCache: maxWidthDiskCache,
                    imageUrl: url,
                    placeholder: (_, __) => placeholder,
                    errorWidget: (_, __, ___) => errorWidget,
                  )
                : placeholder,
          ),
        ),
      ),
    );
  }
}
