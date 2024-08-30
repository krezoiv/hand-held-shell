import 'package:hand_held_shell/config/global/environment.dart';

class PurchasesOrderApi {
  static String createPurchasesOrderApi =
      '${Environment.apiUrl}/purchaseOrder/createPurchaseOrders';

  static String createPurchaseOrder() {
    return createPurchasesOrderApi;
  }
}
