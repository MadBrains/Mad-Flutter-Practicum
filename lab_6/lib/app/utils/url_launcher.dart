import 'package:url_launcher/url_launcher_string.dart';

Future<void> tryLaunchUrl(String url, [LaunchMode? mode]) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url, mode: mode ?? LaunchMode.externalApplication);
  }
}
