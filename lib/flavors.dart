enum Flavor {
  local,
  dev,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? 'unknown';

  static String get title {
    switch (appFlavor) {
      case Flavor.local:
        return 'L.PumpProgress';
      case Flavor.dev:
        return 'D.PumpProgress';
      case Flavor.prod:
        return 'PumpProgress';
      default:
        return 'title';
    }
  }
}
