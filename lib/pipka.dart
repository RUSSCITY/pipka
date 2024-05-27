import 'dart:ui';

import 'pipka_platform_interface.dart';

class Pipka {

  /// Called when the app enters PIP mode
  VoidCallback? onPipEntered;

  /// Called when the app exits PIP mode
  VoidCallback? onPipExited;

  Pipka() {
      PipkaPlatform.instance.init();
  }

  Future<void> setOnPipEntered(VoidCallback onPipEntered){
    return PipkaPlatform.instance.setOnPipEntered(onPipEntered);
  }


  Future<void> setOnPipExited(VoidCallback onPipExited){
    return PipkaPlatform.instance.setOnPipExited(onPipExited);
  }


  Future<String?> getPlatformVersion() {
    return PipkaPlatform.instance.getPlatformVersion();
  }

  Future<bool?> isPipAvailable() {
    return PipkaPlatform.instance.isPipAvailable();
  }

  Future<bool?> isPipActivated() {
    return PipkaPlatform.instance.isPipActivated();
  }

  Future<bool?> isAutoPipAvailable() {
    return PipkaPlatform.instance.isAutoPipAvailable();
  }

  Future<bool?> enterPipMode({
    aspectRatio = const [16, 9],
    autoEnter = false,
    seamlessResize = false,
  }) {
    Map params = {
      'aspectRatio': aspectRatio,
      'autoEnter': autoEnter,
      'seamlessResize': seamlessResize,
    };
    return PipkaPlatform.instance.enterPipMode(params);
  }

  Future<bool?> setAutoPipMode({
    aspectRatio = const [16, 9],
    autoEnter = true,
    seamlessResize = false,
  }) {
    Map params = {
      'aspectRatio': aspectRatio,
      'autoEnter': autoEnter,
      'seamlessResize': seamlessResize,
    };
    return PipkaPlatform.instance.setAutoPipMode(params);
  }
}
