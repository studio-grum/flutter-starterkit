import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../data/revenue_cat_repository.dart';
import '../domain/purchase_repository.dart';

final purchaseRepositoryProvider = Provider<PurchaseRepository>(
  (_) => RevenueCatRepository(),
);

final offeringsProvider = FutureProvider<Offerings>((ref) {
  return ref.watch(purchaseRepositoryProvider).getOfferings();
});

final customerInfoProvider = FutureProvider<CustomerInfo>((ref) {
  return ref.watch(purchaseRepositoryProvider).getCustomerInfo();
});

final isPremiumProvider = FutureProvider<bool>((ref) async {
  final info = await ref.watch(customerInfoProvider.future);
  return ref
      .read(purchaseRepositoryProvider)
      .hasEntitlement(info, AppConstants.entitlementPremium);
});

class PaywallNotifier extends AsyncNotifier<CustomerInfo?> {
  @override
  Future<CustomerInfo?> build() async {
    return ref.watch(purchaseRepositoryProvider).getCustomerInfo();
  }

  Future<void> purchase(Package package) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(purchaseRepositoryProvider).purchasePackage(package),
    );
  }

  Future<void> restore() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(purchaseRepositoryProvider).restorePurchases(),
    );
  }
}

final paywallNotifierProvider =
    AsyncNotifierProvider<PaywallNotifier, CustomerInfo?>(PaywallNotifier.new);
