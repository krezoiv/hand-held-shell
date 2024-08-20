import 'package:hand_held_shell/config/global/environment.dart';

class VoucherApi {
  static String createVoucherApi =
      '${Environment.apiUrl}/vouchers/createVouchers';

  static String getVouchersApi =
      '${Environment.apiUrl}/vouchers/getVouchersSaleControl';

  static String deleteVoucherApi(String voucherId) {
    return '${Environment.apiUrl}/vouchers/deleteVoucher/$voucherId';
  }

  static String createVoucher() {
    return createVoucherApi;
  }

  static String getVouchers() {
    return getVouchersApi;
  }

  static String deleteVoucher(String voucherId) {
    return deleteVoucherApi(voucherId);
  }
}
