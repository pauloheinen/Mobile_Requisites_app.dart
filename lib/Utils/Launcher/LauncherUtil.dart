import 'package:url_launcher/url_launcher.dart';

class LauncherUtil {
  static launch(String url) async {
    Uri uri;

    if (!url.startsWith("https:")) {
      uri = Uri.parse("https://$url");
    } else {
      uri = Uri.parse(url);
    }

    try
    {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } on Exception catch( e ) {
      return false;
    }
  }
}
