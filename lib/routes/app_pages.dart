import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:milk_bazzar/modules/Merchant/add_customer/screens/add_customer_screen.dart';
import 'package:milk_bazzar/modules/Merchant/pending_customer_list/screens/pending_customer_list_screen.dart';
import 'package:milk_bazzar/modules/Merchant/sell_milk/screens/sell_milk_screen.dart';
import '../modules/Customer/generate_bill/screens/generate_bill_screen.dart';
import '../modules/Customer/invoice_bill/screens/invoice_screen.dart';
import '../modules/Customer/language/screens/language_screen.dart';
import '../modules/Customer/login/screens/login_screen.dart';
import '../modules/Customer/mode/screens/mode_screen.dart';
import '../modules/Customer/otp/screens/otp_verification_screen.dart';
import '../modules/Customer/profile/screens/profile_screen.dart';
import '../modules/Customer/register/screens/register_screen.dart';
import '../modules/Customer/settings/screens/settings_screen.dart';
import '../modules/Customer/splash/screens/splash_screen.dart';
import '../modules/Customer/terms&conditions/screens/terms&conditions_screen.dart';
import '../modules/Customer/welcome_screen/screens/welcome_screen.dart';
import '../modules/Merchant/customer_category/screens/customer_category_screen.dart';
import '../modules/Merchant/customer_list/screens/customer_list_screen.dart';
import '../modules/Merchant/generate_bill_merchant/screens/generate_bill_merchant_screen.dart';
import '../modules/Merchant/home/screens/home_screen.dart';
import '../modules/Merchant/payment/screens/payment_screen.dart';
import '../modules/Merchant/select_customer/screens/select_customer_screen.dart';
import 'app_routes.dart';

class AppPages{

  static String initialRoutes = AppRoutes.splash;

  static List<GetPage> routes = [

    // TODO: Customer

    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.otpVerification, page: () => const OtpVerificationScreen()),
    GetPage(name: AppRoutes.welcome, page: () => const WelcomeScreen()),
    GetPage(name: AppRoutes.invoice, page: () => const InvoiceScreen()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: AppRoutes.language, page: () => const LanguageScreen()),
    GetPage(name: AppRoutes.termsConditions, page: () => const TermsConditionsScreen()),
    GetPage(name: AppRoutes.mode, page: () => const ModeScreen()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.generateBill, page: () => const GenerateBillScreen()),

   // TODO: Merchant

    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.sellMilk, page: () => const SellMilkScreen()),
    GetPage(name: AppRoutes.selectCustomer, page: () => const SelectCustomerScreen()),
    GetPage(name: AppRoutes.addCustomer, page: () => const AddCustomerScreen()),
    GetPage(name: AppRoutes.customerCategory, page: () => const CustomerCategoryScreen()),
    GetPage(name: AppRoutes.generateBillMerchant, page: () => const GenerateBillMerchantScreen()),
    GetPage(name: AppRoutes.payment, page: () => const PaymentScreen()),
    GetPage(name: AppRoutes.customerList, page: () => const CustomerListScreen()),
    GetPage(name: AppRoutes.pendingCustomerList, page: () => const PendingCustomerListScreen()),

  ];

}