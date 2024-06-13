import Flutter
import UIKit

public class DstPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dst", binaryMessenger: registrar.messenger())
        let instance = DstPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "nextDaylightSavingTransitionAfterDate":
            guard let args = call.arguments as? [String: Any],
                  let epochDate = args["date"] as? Int64,
                  let timeZoneName = args["timeZoneName"] as? String,
                  let timeZone = TimeZone(identifier: timeZoneName) else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid or missing arguments", details: nil))
                return
            }
            
            let date = Date(timeIntervalSince1970: TimeInterval(epochDate / 1000))
            if let nextTransitionDate = timeZone.nextDaylightSavingTimeTransition(after: date) {
                let beforeOffset = timeZone.secondsFromGMT(for: date) / 3600 // Convert seconds to hours
                let afterOffset = timeZone.secondsFromGMT(for: nextTransitionDate) / 3600 // Convert seconds to hours
                let offsetChange = afterOffset - beforeOffset
                let isDSTActive = timeZone.isDaylightSavingTime(for: nextTransitionDate)
                let transitionInfo = [
                    "transitionDate": Int(nextTransitionDate.timeIntervalSince1970 * 1000),
                    "offsetChange": offsetChange,
                    "isDSTActive": isDSTActive
                ] as [String : Any]
                result(transitionInfo)
            } else {
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
