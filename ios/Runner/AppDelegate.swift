import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let appWindow = window ?? UIWindow(frame: UIScreen.main.bounds)
    if appWindow.rootViewController == nil {
      appWindow.rootViewController = FlutterViewController()
    }
    window = appWindow

    GeneratedPluginRegistrant.register(with: self)
    let handled = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    appWindow.makeKeyAndVisible()
    return handled
  }
}
