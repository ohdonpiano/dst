import 'package:flutter_test/flutter_test.dart';
import 'package:dst/dst.dart';
import 'package:dst/dst_platform_interface.dart';
import 'package:dst/dst_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDstPlatform with MockPlatformInterfaceMixin implements DstPlatform {
  @override
  Future<DateTime> nextDaylightSavingTransitionAfterDate(
          DateTime date, String timeZoneName) =>
      Future.value(date);
}

void main() {
  final DstPlatform initialPlatform = DstPlatform.instance;

  test('$MethodChannelDst is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDst>());
  });

  test('nextDaylightSavingTransitionAfterDate', () async {
    Dst dstPlugin = Dst();
    MockDstPlatform fakePlatform = MockDstPlatform();
    DstPlatform.instance = fakePlatform;
    final checkDate = DateTime(2024, 1, 1);
    expect(
        await dstPlugin.nextDaylightSavingTransitionAfterDate(
            checkDate, "Europe/Rome"),
        checkDate);
  });
}
