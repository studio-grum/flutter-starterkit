import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveWidget extends StatelessWidget {
  const RiveWidget({
    super.key,
    required this.assetPath,
    this.stateMachineName,
    this.animationName,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.onInit,
  });

  final String assetPath;
  final String? stateMachineName;
  final String? animationName;
  final BoxFit fit;
  final Alignment alignment;
  final void Function(Artboard)? onInit;

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      assetPath,
      stateMachines: stateMachineName != null ? [stateMachineName!] : const [],
      animations: animationName != null ? [animationName!] : const [],
      fit: fit,
      alignment: alignment,
      onInit: onInit,
    );
  }
}
