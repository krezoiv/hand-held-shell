import 'package:hand_held_shell/config/global/environment.dart';

class BillsApi {
  static String createBillsApi = '${Environment.apiUrl}/bills/createBills';

  static String getBillsApi =
      '${Environment.apiUrl}/bills/getBillsSalesControl';

  static String deleteBillApi(String billId) {
    return '${Environment.apiUrl}/bills/deleteBill/$billId';
  }

  static String createBills() {
    return createBillsApi;
  }

  static String getBill() {
    return getBillsApi;
  }

  static String deleteBill(String billId) {
    return deleteBillApi(billId);
  }
}
