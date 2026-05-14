import Flutter
import UIKit
import ActivityKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    var currentActivity: Activity<TimerAttributes>?  // Store the current activity

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "com.xrok.pumpProgress/timer",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "startTimerService" {
        guard let args = call.arguments as? [String: Any],
              let name = args["exercise"] as? String,
              let weight = args["weight"] as? Double,
              let reps = args["reps"] as? Int else {
          result(FlutterError(code: "BAD_ARGS", message: "Missing or invalid arguments", details: nil))
          return
        }
        self?.requestPermissionAndStartActivity(name: name, weight: weight, reps: reps)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
    
    private func requestPermissionAndStartActivity(name: String, weight: Double, reps: Int) {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        guard granted else {
          NSLog("🚫 Notification permission not granted")
          return
        }

        DispatchQueue.main.async {
            let attributes = TimerAttributes(name: name)
            let newState = TimerAttributes.ContentState(name: name, weight: weight, reps: reps, startTime: Date())

            if let activity = self.currentActivity {
                      Task {
                        await activity.update(using: newState)
                        NSLog("🔄 Live Activity updated")
                      }
            } else {
                let attributes = TimerAttributes(name: name)
                do {
                    let activity = try Activity<TimerAttributes>.request(
                        attributes: attributes,
                        contentState: newState,
                        pushType: nil
                    )
                    self.currentActivity = activity
                    NSLog("✅ Live Activity started: \(activity.id)")
                } catch {
                    NSLog("❌ Failed to start Live Activity: \(error.localizedDescription)")
                }
            }
        }
      }
   }
}
