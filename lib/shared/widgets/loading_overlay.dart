import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.lottieAsset,
  });

  final bool isLoading;
  final Widget child;
  final String? lottieAsset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black38,
            child: Center(
              child: lottieAsset != null
                  ? Lottie.asset(lottieAsset!, width: 120)
                  : const CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
