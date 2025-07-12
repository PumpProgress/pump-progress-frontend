import Flutter
import UIKit
import ActivityKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

      
      
      
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
          if granted {
              DispatchQueue.main.async {
                  // Aquí iniciar la Live Activity
                  let attributes = TimerAttributes(name: "PumpProgress")
                  let state = TimerAttributes.ContentState(emoji: "💪")
                  do {
                      let activity = try Activity<TimerAttributes>.request(
                          attributes: attributes,
                          contentState: state,
                          pushType: nil
                      )
                      NSLog("✅ Live Activity started: \(activity.id)")
                  } catch {
                      NSLog("❌ Failed to start Live Activity: \(error.localizedDescription)")
                  }
              }
          } else {
              NSLog("🚫 Permisos de notificación denegados")
          }
      }
      
      
      let controller = window?.rootViewController as! FlutterViewController
          let channel = FlutterMethodChannel(name: "com.xrok.pumpProgress/timer",
                                             binaryMessenger: controller.binaryMessenger)

          channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "startTimerService" {
//              guard let args = call.arguments as? [String: Any],
//                    let name = args["name"] as? String,
//                    let emoji = args["emoji"] as? String else {
//                result(FlutterError(code: "BAD_ARGS", message: "Invalid arguments", details: nil))
//                return
//              }

              self.requestPermissionAndStartActivity(name: "name", emoji: "😀")
              result(nil)
            } else {
              result(FlutterMethodNotImplemented)
            }
          }
      
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func requestPermissionAndStartActivity(name: String, emoji: String) {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        guard granted else {
          NSLog("🚫 Notification permission not granted")
          return
        }

        DispatchQueue.main.async {
          let attributes = TimerAttributes(name: name)
          let state = TimerAttributes.ContentState(emoji: emoji)
          do {
            let activity = try Activity<TimerAttributes>.request(
              attributes: attributes,
              contentState: state,
              pushType: nil
            )
            NSLog("✅ Live Activity started: \(activity.id)")
          } catch {
            NSLog("❌ Failed to start Live Activity: \(error.localizedDescription)")
          }
        }
      }
    }
}
