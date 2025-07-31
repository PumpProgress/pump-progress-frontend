// Place fonts/icomoon.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: icomoon
//      fonts:
//       - asset: fonts/icomoon.ttf
import 'package:flutter/widgets.dart';

class Icomoon {
  Icomoon._();

  static const String _fontFamily = 'icomoon';

  static const IconData icon_apple = IconData(0xe905, fontFamily: _fontFamily);
  static const IconData icon_google = IconData(0xe906, fontFamily: _fontFamily);
  static const IconData icon_thunder = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData icon_dumbell = IconData(0xe901, fontFamily: _fontFamily);
  static const IconData icon_calendar = IconData(0xe902, fontFamily: _fontFamily);
  static const IconData icon_community = IconData(0xe903, fontFamily: _fontFamily);
  static const IconData icon_home = IconData(0xe904, fontFamily: _fontFamily);
}
