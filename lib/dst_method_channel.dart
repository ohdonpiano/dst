import 'package:dst/dst_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dst_platform_interface.dart';

/// An implementation of [DstPlatform] that uses method channels.
class MethodChannelDst extends DstPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dst');

  @override
  Future<DstTransition?> nextDaylightSavingTransitionAfterDate(
      DateTime date, String timeZoneName) async {
    final res = await methodChannel
        .invokeMethod<Map>('nextDaylightSavingTransitionAfterDate', {
      'date': date.millisecondsSinceEpoch,
      'timeZoneName': timeZoneName,
    });
    return (res?.containsKey("transitionDate") == true &&
            res?.containsKey("offsetChange") == true &&
            res?.containsKey("isDSTActive") == true)
        ? DstTransition(
            DateTime.fromMillisecondsSinceEpoch(res!["transitionDate"]),
            res["offsetChange"],
            res["isDSTActive"])
        : null;
  }
}
