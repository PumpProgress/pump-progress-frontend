enum Flavor {
  local,
  dev,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.local:
        return 'L.PumpProgress';
      case Flavor.dev:
        return 'D.PumpProgress';
      case Flavor.prod:
        return 'PumpProgress';
    }
  }

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
    }
  }
}
