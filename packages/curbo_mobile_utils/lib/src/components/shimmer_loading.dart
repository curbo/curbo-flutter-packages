import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'animated_indexed_stack.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    Key? key,
    this.loading = false,
    required this.child,
  }) : super(key: key);

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedIndexedStack(
      index: loading ? 0 : 1,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: child,
        ),
        child,
      ],
    );
  }
}
