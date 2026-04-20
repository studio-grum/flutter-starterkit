import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import 'paywall_provider.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offeringsAsync = ref.watch(offeringsProvider);
    final paywallState = ref.watch(paywallNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium 업그레이드'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: offeringsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (offerings) {
          final packages = offerings.current?.availablePackages ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.workspace_premium, size: 72, color: AppColors.primary)
                    .animate()
                    .scale(duration: 400.ms, curve: Curves.elasticOut),
                const Gap(16),
                Text(
                  'Premium 멤버십',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const Gap(8),
                const Text(
                  '모든 기능을 제한 없이 이용하세요',
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms),
                const Gap(32),
                ...packages.map((p) => _PackageTile(
                      package: p,
                      isLoading: paywallState.isLoading,
                      onPurchase: () => ref
                          .read(paywallNotifierProvider.notifier)
                          .purchase(p),
                    )),
                const Gap(16),
                AppButton(
                  label: '구매 복원',
                  outlined: true,
                  isLoading: paywallState.isLoading,
                  onPressed: () =>
                      ref.read(paywallNotifierProvider.notifier).restore(),
                ).animate().fadeIn(delay: 500.ms),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({
    required this.package,
    required this.isLoading,
    required this.onPurchase,
  });

  final Package package;
  final bool isLoading;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.storeProduct.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    package.storeProduct.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            AppButton(
              label: package.storeProduct.priceString,
              isLoading: isLoading,
              onPressed: onPurchase,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}
