class AppImages {

  static const String fromImages = 'assets/images/';
  static const String fromIcons = 'assets/icons/';

  static String imagePath(String name) => '$fromImages$name';
  static String iconPath(String name) => '$fromIcons$name';

  static final String appLogo = imagePath('app_logo.png');

}