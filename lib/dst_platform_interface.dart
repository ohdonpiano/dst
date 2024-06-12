import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dst_method_channel.dart';

abstract class DstPlatform extends PlatformInterface {
  /// Constructs a DstPlatform.
  DstPlatform() : super(token: _token);

  static final Object _token = Object();

  static DstPlatform _instance = MethodChannelDst();

  /// The default instance of [DstPlatform] to use.
  ///
  /// Defaults to [MethodChannelDst].
  static DstPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DstPlatform] when
  /// they register themselves.
  static set instance(DstPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<DateTime?> nextDaylightSavingTransitionAfterDate(
      DateTime date, String timeZoneName) {
    throw UnimplementedError(
        'nextDaylightSavingTransitionAfterDate() has not been implemented.');
  }
}
