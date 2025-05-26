import 'package:pump_progress_frontend/flavors.dart';

class FlavorConfig {
  static String get baseUrl {
    // TODO this should be an environment variable
    const urlProd =
        'https://23xlv17ugb.execute-api.us-east-1.amazonaws.com/api';

    const urlLocal = 'http://localhost:6000';

    switch (F.appFlavor) {
      case Flavor.local:
        return urlLocal;
      case Flavor.dev:
      case Flavor.prod:
        return urlProd;
      default:
        throw Exception('Flavor not implemented');
    }
  }
}
