
import UIKit
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    registerForPushNotifications(application)
    UITabBar.appearance().barTintColor = UIColor.themeGreenColor
    UITabBar.appearance().tintColor = UIColor.whiteColor()

    // Check if launched from notification
    // 1
    if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
        // 2
        print ("check if launched")
        let aps = notification["aps"] as! [String: AnyObject]
        createNewGlassItem(aps)
        // 3
        (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
    }
    
    
    return true
  }

  // MARK: Helpers
  func createNewGlassItem(notificationDictionary:[String: AnyObject]) -> GlassItem? {
    print("createNewGlassItem.....")
    if let glass = notificationDictionary["alert"] as? String,
      let url = notificationDictionary["link_url"] as? String {
        let date = NSDate()
        let subtitle = "HELP!!"
        let glassItem = GlassItem(title: glass, date: date, link: url, subtitle: subtitle)
        let glassStore = GlassStore.sharedStore
        glassStore.addItem(glassItem)

        NSNotificationCenter.defaultCenter().postNotificationName(GlassFeedTableViewController.RefreshGlassFeedNotification, object: self)
        return glassItem
    }
    return nil
  }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        print("RegisterForPushNotifcations", notificationSettings )
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
            print("didRegisterUserNotifcationSettings")
        }
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        createNewGlassItem(aps)
        print("didReceiveNotify", aps)
    }
    /*
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("didReceiveRemoteNotification.....")
        print(userInfo)
    }*/
}

