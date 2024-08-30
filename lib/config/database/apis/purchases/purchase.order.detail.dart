import 'package:hand_held_shell/config/global/environment.dart';

class PurchasesOrderDetailApi {
  static String createAllPurchasesOrderDetailApi =
      '${Environment.apiUrl}/purchaseOrder/createAllDetailPurchaseOrders';

  static String updatePurchasesOrderDetailApi =
      '${Environment.apiUrl}/purchaseOrder/updateOrderDetail';

  static String createAllPurchasesOrderDetail() {
    return createAllPurchasesOrderDetailApi;
  }

  static String updatePurchasesOrderDetail() {
    return updatePurchasesOrderDetailApi;
  }
}
