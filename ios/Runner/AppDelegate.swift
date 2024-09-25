import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import Lottie
import app_links  // Import the app_links package

@main
@objc class AppDelegate: FlutterAppDelegate {
   lazy var flutterEngine = FlutterEngine(name: "PzDeals")
   
   override func application(
     _ application: UIApplication,
     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
   ) -> Bool {
     // Firebase setup
     FirebaseApp.configure()
     flutterEngine.run()
     GeneratedPluginRegistrant.register(with: self.flutterEngine)
     
     // Retrieve the link from launch options (App Links integration)
     if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
       // Handle the app link
       AppLinks.shared.handleLink(url: url)
       return true  // Stops propagation to other packages
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
