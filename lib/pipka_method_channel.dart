import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pipka_platform_interface.dart';

/// An implementation of [PipkaPlatform] that uses method channels.
class MethodChannelPipka extends PipkaPlatform {
  /// Called when the app enters PIP mode
  VoidCallback? onPipEntered;

  /// Called when the app exits PIP mode
  VoidCallback? onPipExited;

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('de.russcity.pipka');

  @override
  Future<void> init() async {
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onPipEntered':
          print("Call back entered pip ${onPipEntered == null}");
          onPipEntered?.call();
          break;
        case 'onPipExited':
          onPipExited?.call();
          break;
      }
    });
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> isPipAvailable() async {
    return await methodChannel.invokeMethod<bool>('isPipAvailable');
  }

  @override
  Future<bool?> isPipActivated() async {
    return await methodChannel.invokeMethod<bool>('isPipActivated');
  }

  @override
  Future<bool?> isAutoPipAvailable() async {
    return await methodChannel.invokeMethod<bool>('isAutoPipAvailable');
  }

  @override
  Future<bool?> enterPipMode(Map<dynamic, dynamic> params) async {
    return await methodChannel.invokeMethod<bool>('enterPipMode', params);
  }

  @override
  Future<bool?> setAutoPipMode(Map<dynamic, dynamic> params) async {
    return await methodChannel.invokeMethod<bool>('setAutoPipMode', params);
  }

  @override
  Future<void> setOnPipEntered(VoidCallback onPipEntered) async {
    this.onPipEntered = onPipEntered;
  }

  @override
  Future<void> setOnPipExited(VoidCallback onPipExited) async {
    this.onPipExited = onPipExited;
  }
}
