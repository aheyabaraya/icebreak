import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';

class IapStub {
  IapStub({Logger? logger}) : _log = logger ?? Logger();

  final Logger _log;
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<void> queryProducts(Set<String> productIds) async {
    // TODO: replace with real product IDs and purchasing flow.
    final available = await _iap.isAvailable();
    if (!available) {
      _log.w('IAP not available on this device/emulator.');
      return;
    }

    final response = await _iap.queryProductDetails(productIds);
    if (response.error != null) {
      _log.e('IAP query error', error: response.error);
      return;
    }

    _log.i('IAP products: ${response.productDetails.length}');
  }
}

