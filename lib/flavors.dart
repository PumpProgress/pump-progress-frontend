enum Flavor {
  local,
  dev,
  prod,
}

class F {
  static Flavor appFlavor = Flavor.local;

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
}
