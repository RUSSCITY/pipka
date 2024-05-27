import 'package:flutter_test/flutter_test.dart';
import 'package:pipka/pipka.dart';
import 'package:pipka/pipka_platform_interface.dart';
import 'package:pipka/pipka_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPipkaPlatform
    with MockPlatformInterfaceMixin
    implements PipkaPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PipkaPlatform initialPlatform = PipkaPlatform.instance;

  test('$MethodChannelPipka is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPipka>());
  });

  test('getPlatformVersion', () async {
    Pipka pipkaPlugin = Pipka();
    MockPipkaPlatform fakePlatform = MockPipkaPlatform();
    PipkaPlatform.instance = fakePlatform;

    expect(await pipkaPlugin.getPlatformVersion(), '42');
  });
}
