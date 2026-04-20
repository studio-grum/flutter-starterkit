import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/purchase_repository.dart';

class RevenueCatRepository implements PurchaseRepository {
  @override
  Future<Offerings> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      throw PurchaseException(e.toString());
    }
  }

  @override
  Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      return result.customerInfo;
    } catch (e) {
      throw PurchaseException(e.toString());
    }
  }

  @override
  Future<CustomerInfo> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      throw PurchaseException(e.toString());
    }
  }

  @override
  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      throw PurchaseException(e.toString());
    }
  }

  @override
  bool hasEntitlement(CustomerInfo info, String entitlementId) {
    return info.entitlements.active.containsKey(entitlementId);
  }
}
