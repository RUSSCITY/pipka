import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pipka/pipka.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _pipkaPlugin = Pipka();
  bool _isPipAvailable = false;
  bool _isPipActivated = false;
  bool _isAutoPipAvailable = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    checkPipAvailability();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _pipkaPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> checkPipAvailability() async {
    _isPipAvailable = await _pipkaPlugin.isPipAvailable() ?? false;
    _isPipActivated = await _pipkaPlugin.isPipActivated() ?? false;
    _isAutoPipAvailable = await _pipkaPlugin.isAutoPipAvailable() ?? false;
    _pipkaPlugin.setOnPipEntered(() {
      setState(() {
        _isPipActivated = true;
      });
    });
    _pipkaPlugin.setOnPipExited(() {
      setState(() {
        _isPipActivated = false;
      });
    });
    await _pipkaPlugin.setAutoPipMode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion'),
              Text("Is PiP available: $_isPipAvailable"),
              Text("Is PiP activated: $_isPipActivated"),
              Text("Is Auto PiP available: $_isAutoPipAvailable"),
              MaterialButton(
                onPressed: () {
                  _pipkaPlugin.enterPipMode();
                },
                child: const Text("Enter PIP"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
