import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dst_platform_interface.dart';

/// An implementation of [DstPlatform] that uses method channels.
class MethodChannelDst extends DstPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dst');

  @override
  Future<DateTime?> nextDaylightSavingTransitionAfterDate(
      DateTime date, String timeZoneName) async {
    final timestamp = await methodChannel
        .invokeMethod<int>('nextDaylightSavingTransitionAfterDate', {
      'date': date.millisecondsSinceEpoch,
      'timeZoneName': timeZoneName,
    });
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }
}
