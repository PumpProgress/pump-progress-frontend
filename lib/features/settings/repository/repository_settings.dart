import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pump_progress_frontend/features/settings/domain/domain.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Stateless wrapper over the platform plugins used by the Settings screen.
class RepositorySettings {
  final InAppReview _inAppReview;

  RepositorySettings({InAppReview? inAppReview})
      : _inAppReview = inAppReview ?? InAppReview.instance;

  /// Returns the display version, e.g. "4.1.0 (29)".
  Future<String> appVersion() async {
    final info = await PackageInfo.fromPlatform();
    return formatAppVersion(info.version, info.buildNumber);
  }

  /// Opens the privacy policy in an external browser.
  /// Throws if the URL cannot be launched.
  Future<void> openPrivacyPolicy() async {
    final uri = Uri.parse(kPrivacyPolicyUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      throw Exception('Could not open privacy policy');
    }
  }

  /// Requests the native in-app review flow.
  Future<void> rateApp() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    } else {
      await _inAppReview.openStoreListing(appStoreId: '6450376080');
    }
  }

  /// Opens the OS share sheet with the app's store links.
  Future<void> shareApp() async {
    await Share.share(
      'Check out PumpProgress!\n'
      'Android: $kPlayStoreUrl\n'
      'iOS: $kAppStoreUrl',
      subject: 'PumpProgress',
    );
  }
}
