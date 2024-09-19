import 'package:hand_held_shell/config/global/environment.dart';

class PurchasesOrderApi {
  static String createPurchasesOrderApi =
      '${Environment.apiUrl}/purchaseOrder/createPurchaseOrders';

  static String createUpdatePurchasesOrderApi =
      '${Environment.apiUrl}/purchaseOrder/firstUpdatePurchaseOrder';

  static String createPurchaseOrder() {
    return createPurchasesOrderApi;
  }

  static String createUpdatePurchaseOrder() {
    return createUpdatePurchasesOrderApi;
  }
}
