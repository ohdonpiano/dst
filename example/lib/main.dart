import 'package:dst/dst_transition.dart';
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
  DstTransition? _nextDst;
  final timeZoneName = "Europe/Rome";
  final _dstPlugin = Dst();

  @override
  void initState() {
    super.initState();
    _getNextDst();
  }

  Future<void> _getNextDst() async {
    final checkDate = _nextDst?.transitionDate ??
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
                if (_nextDst != null)
                  Text(
                      "Next DST transition in $timeZoneName: ${_nextDst!.offsetChange > 0 ? _nextDst!.transitionDate.subtract(const Duration(seconds: 1)) : _nextDst!.transitionDate.add(const Duration(seconds: 3599))} (Offset ${_nextDst!.offsetChange > 0 ? '+' : ''}${_nextDst!.offsetChange})"
                      "\nDST is active: ${_nextDst!.isDSTActive}"),
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
