import 'package:dst/dst_transition.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:dst/dst.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final timeZoneName1 = "America/New_York";
  final timeZoneName2 = "Europe/Rome";
  DstTransition? _nextDst1;
  DstTransition? _nextDst2;
  final _dstPlugin = Dst();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _getNextDst();
  }

  Future<void> _getNextDst() async {
    final initialDate = DateTime.now()
        .copyWith(month: 1, day: 1, hour: 0, minute: 0, second: 0);
    final checkDate1 = _nextDst1?.transitionDate ?? initialDate;
    final checkDate2 = _nextDst2?.transitionDate ?? initialDate;
    try {
      _nextDst1 = await _dstPlugin.nextDaylightSavingTransitionAfterDate(
          checkDate1, timeZoneName1);
      _nextDst2 = await _dstPlugin.nextDaylightSavingTransitionAfterDate(
          checkDate2, timeZoneName2);
    } on PlatformException {
      //ignore
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localDateTime1 = _nextDst1?.transitionDate != null
        ? tz.TZDateTime.from(
            _nextDst1!.transitionDate, tz.getLocation(timeZoneName1))
        : null;
    final localDateTime2 = _nextDst2?.transitionDate != null
        ? tz.TZDateTime.from(
            _nextDst2!.transitionDate, tz.getLocation(timeZoneName2))
        : null;
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
                if (localDateTime1 != null)
                  Text(
                      "Next DST transition in $timeZoneName1: ${_nextDst1!.offsetChange > 0 ? localDateTime1.subtract(const Duration(seconds: 1)) : localDateTime1.add(const Duration(seconds: 3599))} (Offset ${_nextDst1!.offsetChange > 0 ? '+' : ''}${_nextDst1!.offsetChange})"
                      "\nDST is active: ${_nextDst1!.isDSTActive}"),
                const SizedBox(height: 30),
                if (localDateTime2 != null)
                  Text(
                      "Next DST transition in $timeZoneName2: ${_nextDst2!.offsetChange > 0 ? localDateTime2.subtract(const Duration(seconds: 1)) : localDateTime2.add(const Duration(seconds: 3599))} (Offset ${_nextDst2!.offsetChange > 0 ? '+' : ''}${_nextDst2!.offsetChange})"
                      "\nDST is active: ${_nextDst2!.isDSTActive}"),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: _getNextDst, child: const Text("Get next")),
                TextButton(
                    onPressed: () {
                      _nextDst1 = null;
                      _nextDst2 = null;
                      _getNextDst();
                    },
                    child: const Text("Restart")),
              ],
            ),
          )),
    );
  }
}
