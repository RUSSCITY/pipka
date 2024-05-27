import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pipka_method_channel.dart';

abstract class PipkaPlatform extends PlatformInterface {
  /// Constructs a PipkaPlatform.
  PipkaPlatform() : super(token: _token);

  static final Object _token = Object();

  static PipkaPlatform _instance = MethodChannelPipka();

  /// The default instance of [PipkaPlatform] to use.
  ///
  /// Defaults to [MethodChannelPipka].
  static PipkaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PipkaPlatform] when
  /// they register themselves.
  static set instance(PipkaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> isPipAvailable() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> isPipActivated() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> isAutoPipAvailable() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> enterPipMode(Map<dynamic, dynamic> params) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> setAutoPipMode(Map<dynamic, dynamic> params) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> setOnPipEntered(VoidCallback onPipEntered) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> setOnPipExited(VoidCallback onPipExited) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
