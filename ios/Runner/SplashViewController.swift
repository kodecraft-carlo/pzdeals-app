//import UIKit
//import Lottie
//
//public class SplashViewController: UIViewController {
//    
//    private var animationView: LottieAnimationView?
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Set the background color in viewDidLoad
//        view.backgroundColor = .white
//    }
//    
//    public override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        // Configure and play the Lottie animation
//        animationView = .init(name: "splash_screen")
//        animationView!.backgroundColor = .clear
//
//        // Set the size and position of the animation view based on screen size
//        let screenWidth = view.bounds.width
//        let screenHeight = view.bounds.height
//        let animationSize = min(screenWidth, screenHeight) * 0.6 // 50% of the smaller dimension
//        let animationX = (screenWidth - animationSize) / 2
//        let animationY = (screenHeight - animationSize) / 2
//        animationView!.frame = CGRect(x: animationX, y: animationY, width: animationSize, height: animationSize)
//
//        animationView!.center = view.center
//        animationView!.contentMode = .scaleAspectFit
//        animationView!.loopMode = .playOnce
//        animationView!.animationSpeed = 1.00
//        view.addSubview(animationView!)
//        animationView!.play { (finished) in
//            self.startFlutterApp()
//        }
//    }
//    
//    func startFlutterApp() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let flutterEngine = appDelegate.flutterEngine
//        let flutterViewController =
//            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
//        
//        flutterViewController.modalPresentationStyle = .custom
//        flutterViewController.modalTransitionStyle = .crossDissolve
//        
//        present(flutterViewController, animated: true, completion: nil)
//    }
//}
import UIKit
import Lottie
import Flutter

public class SplashViewController: UIViewController {
    
    private var animationView: LottieAnimationView?
    private let CHANNEL = "app.channel.shared.data"
    private var methodChannel: FlutterMethodChannel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color in viewDidLoad
        view.backgroundColor = .white
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Configure and play the Lottie animation
        animationView = .init(name: "splash_screen")
        animationView!.backgroundColor = .clear

        // Set the size and position of the animation view based on screen size
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        let animationSize = min(screenWidth, screenHeight) * 0.6 // 50% of the smaller dimension
        let animationX = (screenWidth - animationSize) / 2
        let animationY = (screenHeight - animationSize) / 2
        animationView!.frame = CGRect(x: animationX, y: animationY, width: animationSize, height: animationSize)

        animationView!.center = view.center
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1.00
        view.addSubview(animationView!)
        animationView!.play { (finished) in
            self.startFlutterApp()
        }
    }
    
    func setupMethodChannel() {
        // This method is intentionally left empty as a placeholder
        // The actual MethodChannel setup will be done in startFlutterApp
    }

    func startFlutterApp() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let flutterEngine = appDelegate.flutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        flutterViewController.modalPresentationStyle = .custom
        flutterViewController.modalTransitionStyle = .crossDissolve
        
        // Present the FlutterViewController
        present(flutterViewController, animated: true) {
            // Set up the MethodChannel with the actual FlutterViewController's binaryMessenger
            self.methodChannel = FlutterMethodChannel(name: self.CHANNEL, binaryMessenger: flutterViewController.binaryMessenger)
            self.methodChannel?.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                if call.method == "getDeepLink" {
                    // Handle deep link here
                    result("Deep link handled")
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }
}
