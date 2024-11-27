import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "com.example.nexchat/app_icon",
      binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "changeAppIcon",
            let args = call.arguments as? [String: Any],
            let iconName = args["icon"] as? String
      else {
        result(FlutterMethodNotImplemented)
        return
      }
      
      self?.changeAppIcon(to: iconName, result: result)
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func changeAppIcon(to iconName: String, result: @escaping FlutterResult) {
    if UIApplication.shared.supportsAlternateIcons {
      UIApplication.shared.setAlternateIconName(iconName == "Default" ? nil : iconName) { error in
        if let error = error {
          result(FlutterError(code: "CHANGE_ICON_FAILED",
                            message: error.localizedDescription,
                            details: nil))
        } else {
          result(nil)
        }
      }
    } else {
      result(FlutterError(code: "FEATURE_NOT_SUPPORTED",
                        message: "This device does not support alternate icons",
                        details: nil))
    }
  }
}
