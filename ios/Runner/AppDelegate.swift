import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "com.ground17.search-music/process",
                                            binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
    [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
    // Note: this method is invoked on the UI thread.
    guard call.method == "process" else {
      result(FlutterMethodNotImplemented)
      return
    }
    self?.process(result: result)
    })
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func process(result: FlutterResult) { // record and dsp process
  let device = UIDevice.current
  device.isBatteryMonitoringEnabled = true
  if device.batteryState == UIDevice.BatteryState.unknown {
    result(FlutterError(code: "UNAVAILABLE",
                        message: "Battery info unavailable",
                        details: nil))
  } else {
    result(Int(device.batteryLevel * 100))
  }
}
