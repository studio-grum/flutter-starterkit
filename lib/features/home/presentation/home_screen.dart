import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../features/auth/presentation/auth_provider.dart';
import '../../../features/paywall/presentation/paywall_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '안녕하세요 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
            Text(
              user?.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(delay: 100.ms),
            const Gap(8),
            isPremiumAsync.when(
              data: (isPremium) => Chip(
                label: Text(isPremium ? '✨ Premium' : 'Free'),
                backgroundColor: isPremium ? Colors.amber.shade100 : null,
              ),
              loading: () => const SizedBox.shrink(),
              error: (e, st) => const SizedBox.shrink(),
            ).animate().fadeIn(delay: 200.ms),
            const Gap(32),
            const _FeatureCard(
              icon: Icons.workspace_premium,
              title: '결제 / Paywall',
              subtitle: 'RevenueCat 구독 관리',
              route: AppConstants.routePaywall,
            ),
            const Gap(12),
            const _FeatureCard(
              icon: Icons.play_circle_outline,
              title: '동영상 재생',
              subtitle: 'video_player + chewie',
              route: AppConstants.routeVideoPlayer,
              extra: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            ),
            const Gap(12),
            const _FeatureCard(
              icon: Icons.music_note,
              title: '오디오 재생',
              subtitle: 'just_audio + 백그라운드 지원',
              route: AppConstants.routeAudioPlayer,
              extra: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.extra,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push(route, extra: extra),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05);
  }
}
