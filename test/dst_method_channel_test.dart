import 'package:dst/dst_transition.dart';
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
        return DstTransition(DateTime(2024, 1, 1), 1, true);
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('nextDaylightSavingTransitionAfterDate', () async {
    final checkDate = DateTime(2024, 1, 1);
    final res = await platform.nextDaylightSavingTransitionAfterDate(
        checkDate, "Europe/Rome");
    expect(res != null, true);
    expect(res?.transitionDate, checkDate);
    expect(res?.offsetChange, 1);
    expect(res?.isDSTActive, true);
  });
}
