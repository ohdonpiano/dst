import 'dst_platform_interface.dart';

class Dst {

  Future<DateTime?> nextDaylightSavingTransitionAfterDate(DateTime date, String timeZoneName) {
    return DstPlatform.instance.nextDaylightSavingTransitionAfterDate(date, timeZoneName);
  }
}
