//
//  AppDelegate.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/2/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import RealmSwift
import GoogleMaps
import Fabric
import Crashlytics
import UserNotifications
import Firebase
import FirebaseMessaging

let uiRealm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate,UNUserNotificationCenterDelegate , MessagingDelegate
{
    static var locationManager = CLLocationManager()
    public var mainRootNav: UINavigationController?
    static let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    var window: UIWindow?
    var entries : NSDictionary!

    override init()
    {
        super.init()
        FirebaseApp.configure()
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Fabric.with([Crashlytics.self])
        GMSServices.openSourceLicenseInfo()
        GMSServices.provideAPIKey("AIzaSyAgLfq54h5DuzBwBYYg0V5QkVXq4m36yYQ")
        //GMSPlacesClient.provideAPIKey("AIzaSyAmsNhR_0UFDkE8fsQVrCyGD9lazP0FV2s")
        Localizer.DoTheExchange()
        
        startUpdateLocation()
        AppDelegate.locationManager.delegate = self
        AppDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        AppDelegate.locationManager.startUpdatingLocation()
        AppDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        setupRemoteNotifications(application, withOptions: launchOptions)
        
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
        else
        {
            print("Location services are not enabled")
        }
        
        let vc : RootViewController = AppDelegate.storyboard.instanceVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        IQKeyboardManager.sharedManager().enable = true
        
        UINavigationBar.appearance().barTintColor = MyTools.tools.colorWithHexString("43CBF5")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        
//        let shadow = NSShadow()
//        shadow.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
//        shadow.shadowColor! = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey.font: UIFont(name: "GEDinarTwo-Medium", size: CGFloat(20.0))!, NSAttributedStringKey.shadow: shadow]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "RootViewController") as? RootViewController
        if let window = self.window
        {
            window.rootViewController = tabBarController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        #if !((arch(i386) || arch(x86_64)) && os(iOS)) // !TARGET_IPHONE_SIMULATOR
        print("Error in registration. Error: \(error)");
        #endif
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func setupRemoteNotifications(_ application: UIApplication, withOptions launchOptions: [AnyHashable: Any]?)
    {
        #if !((arch(i386) || arch(x86_64)) && os(iOS)) // !TARGET_IPHONE_SIMULATOR
        
        
        if #available(iOS 10.0, *)
        {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().remoteMessageDelegate = self
            
        }
        else
        {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Clear application badge when app launches - if registered for it
        if let settings = UIApplication.shared.currentUserNotificationSettings {
            if settings.types.contains( .badge )
            {
                UIApplication.shared.applicationIconBadgeNumber = 0;
            }
        }
        
        #endif
    }
    
    func connectToFcm()
    {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().shouldEstablishDirectChannel = false
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    //
    //    /// The callback to handle data message received via FCM for devices running iOS 10 or above.
    public func application(received remoteMessage: MessagingRemoteMessage)
    {
        print(remoteMessage.appData)
    }
    //
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        if let refreshedToken = InstanceID.instanceID().token()
        {
            if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
            {
                UserDefaults.standard.setValue(refreshedToken, forKey: "deviceToken")
                let id = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
                if (id != nil && id != "0")
                {
                    MyApi.api.RefreshDeviceTokenWith(pk_i_id: Int(id)!, DeviceToken: refreshedToken )
                    { (response, err) in
                        if((err) == nil)
                        {
                            if let JSON = response.result.value as? NSDictionary
                            {
                                
                            }
                            else
                            {
                                
                            }
                        }
                        else
                        {
                            
                        }
                    }
                }
            }
        }
        connectToFcm()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        InstanceID.instanceID().setAPNSToken(deviceToken, type: .prod)
        if let refreshedToken = InstanceID.instanceID().token()
        {
            UserDefaults.standard.setValue(refreshedToken, forKey: "deviceToken")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations[0] as CLLocation
    }
    
    func startUpdateLocation()
    {
        
        // Ask for user authorization when getting location
        AppDelegate.locationManager.requestAlwaysAuthorization()
        AppDelegate.locationManager.requestWhenInUseAuthorization()
    }

}

