import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  // @available(iOS 10.0, *)
  // extension AppDelegate: UNUserNotificationCenterDelegate {
  //   func userNotificationCenter(
  //       _ center: UNUserNotificationCenter,
  //       willPresent notification: UNNotification,
  //       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  //   ) {
  //       completionHandler([.alert, .sound, .badge])  // Show alert, play sound, and update badge
  //   }
  // }
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDulurCIwalUxwEFJtmEbDE7aAYQH5KnvY")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
