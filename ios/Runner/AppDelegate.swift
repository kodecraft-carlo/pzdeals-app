import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import Lottie
import app_links

@main
@objc class AppDelegate: FlutterAppDelegate {
   lazy var flutterEngine = FlutterEngine(name: "PzDeals")
 override func application(
   _ application: UIApplication,
   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
 ) -> Bool {
   FirebaseApp.configure()
   flutterEngine.run()
   GeneratedPluginRegistrant.register(with: self.flutterEngine)

    // Retrieve the link from parameters
    if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
      // We have a link, propagate it to your Flutter app or not
      AppLinks.shared.handleLink(url: url)
      return true // Returning true will stop the propagation to other packages
    }

   return super.application(application, didFinishLaunchingWithOptions: launchOptions)
 }

 override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
   Messaging.messaging().apnsToken = deviceToken
   super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
 }
}
// import UIKit
// import Flutter
// import Firebase
// import FirebaseMessaging
// import Lottie

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//     lazy var flutterEngine = FlutterEngine(name: "PzDeals")
//     private let CHANNEL = "app.channel.shared.data"

//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
//         FirebaseApp.configure()
//         flutterEngine.run()
//         GeneratedPluginRegistrant.register(with: self.flutterEngine)

//         // Set up the MethodChannel in the SplashViewController
//         if let controller = window?.rootViewController as? SplashViewController {
//             controller.setupMethodChannel()
//         }

//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }

//     override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//         // Ensure the rootViewController is a FlutterViewController
//         if let controller = window?.rootViewController as? FlutterViewController {
//             let methodChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
//             methodChannel.invokeMethod("getDeepLink", arguments: url.absoluteString)
//         }
        
//         return super.application(app, open: url, options: options)
//     }

//     override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//         Messaging.messaging().apnsToken = deviceToken
//         super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//     }
// }
