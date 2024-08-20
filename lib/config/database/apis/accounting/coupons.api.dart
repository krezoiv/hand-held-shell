import 'package:hand_held_shell/config/global/environment.dart';

class CouponApi {
  static String createCouponApi = '${Environment.apiUrl}/coupons/createCoupons';
  static String getCouponsApi =
      '${Environment.apiUrl}/coupons/getCouponsSalesControl';

  static String deleteVoucherApi(String couponId) {
    return '${Environment.apiUrl}/coupons/deleteCoupons/$couponId';
  }

  static String createCoupon() {
    return createCouponApi;
  }

  static String getCoupons() {
    return getCouponsApi;
  }

  static String deleteCoupon(String couponId) {
    return deleteVoucherApi(couponId);
  }
}
