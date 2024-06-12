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
            if let nextTransition = timeZone.nextDaylightSavingTimeTransition(after: date) {
                result(Int(nextTransition.timeIntervalSince1970 * 1000))
            } else {
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
