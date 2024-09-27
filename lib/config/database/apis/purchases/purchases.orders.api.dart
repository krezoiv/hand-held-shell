import 'package:hand_held_shell/config/global/environment.dart';

class PurchasesOrderApi {
  static String createPurchasesOrderApi =
      '${Environment.apiUrl}/purchaseOrder/createPurchaseOrders';

  static String createUpdatePurchasesOrderApi =
      '${Environment.apiUrl}/purchaseOrder/firstUpdatePurchaseOrder';

  static String getPurchaseOrderByOrderNumberApi(String orderNumber) {
    return '${Environment.apiUrl}/purchaseOrder/findOrderNumber/$orderNumber';
  }

  static String createPurchaseOrder() {
    return createPurchasesOrderApi;
  }

  static String createUpdatePurchaseOrder() {
    return createUpdatePurchasesOrderApi;
  }

  static getPurchaseOrderByOrderNumber(String orderNumber) {
    return getPurchaseOrderByOrderNumberApi(orderNumber);
  }
}
