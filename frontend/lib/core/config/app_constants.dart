class AppConstants {
  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator
  // static const String baseUrl = 'http://localhost:3000'; // iOS simulator / web
  // static const String baseUrl = 'https://your-api.com';

  static const String appName = 'Sharp Deals';

  // Roles (must match your backend)
  static const String roleCustomer = 'customer';
  static const String roleMerchant = 'merchant';

  // Promo types from backend
  static const String promoStandard = 'standard';
  static const String promoMicro = 'micro';

  // Default location radius (km)
  static const double defaultRadiusKm = 5.0;
}