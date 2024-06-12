package com.lib.dst

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*

/** DstPlugin */
class DstPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dst")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "nextDaylightSavingTransitionAfterDate") {
            val args = call.arguments<Map<String, Any>>()!!
            val dateLong = args["date"] as? Long
            val timeZoneName = args["timeZoneName"] as? String
            if (dateLong == null || timeZoneName == null) {
                result.success(null)
                return
            }
            val date = Date(dateLong)
            val timeZone = TimeZone.getTimeZone(timeZoneName)

            val nextTransition = getNextDSTTransition(date, timeZone)
            if (nextTransition != null) {
                result.success(nextTransition.time)
            } else {
                result.success(null)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getNextDSTTransition(date: Date, timeZone: TimeZone): Date? {
        val calendar = Calendar.getInstance(timeZone)
        calendar.time = date

        val currentDST = timeZone.inDaylightTime(calendar.time)
        val oneHour = 60 * 60 * 1000 // 1 hour in milliseconds

        // Check each hour for the next 365 days
        for (hour in 0 until 24 * 365) {
            calendar.add(Calendar.MILLISECOND, oneHour)
            if (timeZone.inDaylightTime(calendar.time) != currentDST) {
                // Refine search to the exact minute when DST changes
                return refineToExactMinute(calendar, timeZone, currentDST)
            }
        }
        return null
    }

    private fun refineToExactMinute(
        calendar: Calendar,
        timeZone: TimeZone,
        previousDST: Boolean
    ): Date {
        val oneMinute = 60 * 1000 // 1 minute in milliseconds
        calendar.add(Calendar.HOUR_OF_DAY, -1) // Go back one hour to the hour before DST change

        for (minute in 0 until 60) {
            calendar.add(Calendar.MILLISECOND, oneMinute)
            if (timeZone.inDaylightTime(calendar.time) != previousDST) {
                return calendar.time
            }
        }
        return calendar.time // Fallback, should not happen in theory
    }
}
