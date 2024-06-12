import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dst/dst_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDst platform = MethodChannelDst();
  const MethodChannel channel = MethodChannel('dst');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return DateTime(2024, 1, 1);
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(
        await platform.nextDaylightSavingTransitionAfterDate(
            DateTime(2024, 1, 1), "Europe/Rome"),
        DateTime(2024, 1, 1));
  });
}
