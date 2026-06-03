/// Centralised asset paths so feature code never sprinkles raw strings.
///
/// When you add a new image/svg into `assets/`, register it here.
class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';
  static const String _onboarding = '$_images/onboarding';
  static const String _home = '$_images/home';

  // Brand
  static const String logo = '$_images/knocksy_logo.png';
  static const String kIcon = '$_home/k_icon.png';
  static const String kIconSvg = '$_home/k_icon.svg';

  // Onboarding artwork (reused from the dashboard login design).
  static const String signInGirl = '$_onboarding/sign_in_girl.png';

  // Icons
  static const String iconIndia = '$_icons/india_flag.png';

  // Bottom-nav icons (SVG, tinted at runtime). Drop these files in:
  static const String navHome = '$_icons/nav_home.svg';
  static const String navExplore = '$_icons/nav_explore.svg';
  static const String navChat = '$_icons/nav_chat.svg';
  static const String navProfile = '$_icons/nav_profile.svg';

  // Home — drop matching PNGs into `assets/images/home/` and the cards
  // pick them up automatically. Until then the widgets fall back to a
  // gradient + icon so the build never breaks.
  static const String firstTimeHiker = '$_home/first_time_hiker.png';

  // Renter — Quick Action icons. Fall back to coloured Material icons until
  // these PNGs are dropped in.
  static const String qaInvoices = '$_home/qa_invoices.png';
  static const String qaTransactions = '$_home/qa_transactions.png';
  static const String qaDocuments = '$_home/qa_documents.png';

  // Payment summary — Knocksy Guarantees illustrations. Fall back to painted
  // icon badges until these PNGs are dropped in.
  static const String guaranteeShield = '$_home/guarantee_shield.png';
  static const String guaranteeVerified = '$_home/guarantee_verified.png';

  // Payment summary — PayPal / Mastercard / Visa logo strip. Falls back to
  // coloured text chips until this PNG is dropped in.
  static const String payMethods = '$_home/pay_methods.png';
}
