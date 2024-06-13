import 'package:dst/dst_transition.dart';

import 'dst_platform_interface.dart';

class Dst {

  Future<DstTransition?> nextDaylightSavingTransitionAfterDate(DateTime date, String timeZoneName) {
    return DstPlatform.instance.nextDaylightSavingTransitionAfterDate(date, timeZoneName);
  }
}
