import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dst/dst.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? _nextDst;
  final timeZoneName = "Europe/Rome";
  final _dstPlugin = Dst();

  @override
  void initState() {
    super.initState();
    _getNextDst();
  }

  Future<void> _getNextDst() async {
    final checkDate = _nextDst ??
        DateTime.now()
            .copyWith(month: 1, day: 1, hour: 0, minute: 0, second: 0);
    try {
      _nextDst = await _dstPlugin.nextDaylightSavingTransitionAfterDate(
          checkDate, timeZoneName);
    } on PlatformException {
      //ignore
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('DST example app'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text('Next DST in $timeZoneName: ${_nextDst ?? ""}'),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: _getNextDst, child: const Text("Get next")),
                TextButton(
                    onPressed: () {
                      _nextDst = null;
                      _getNextDst();
                    },
                    child: const Text("Restart")),
              ],
            ),
          )),
    );
  }
}
