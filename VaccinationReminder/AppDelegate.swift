//
//  AppDelegate.swift
//  VaccinationReminder
//
//  Created by Sahil Dhawan on 05/05/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import GooglePlacePicker
import FBSDKCoreKit
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate , UNUserNotificationCenterDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //fabric
        Fabric.with([Crashlytics.self])
        
        //        let pagingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let pagingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        self.window?.rootViewController = pagingViewController
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        FirebaseApp.configure()
        
        //googlePlacesAPI
        GMSPlacesClient.provideAPIKey(GooglePlacesConstants.queryValues.apiKey)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //userNotification Authorisation
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (accepted, error) in
            if !accepted {
                print("Notification Denied")
            }
            else {
                UNUserNotificationCenter.current().delegate = self
            }
        }
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
    
    
    func scheduleNotifications(_ date : Date , _ msg : String , title : String ) {
        var dayComponents = Calendar.current.dateComponents([.month,.day,.year], from: date)
        let timeComponents = Calendar.current.dateComponents([.hour , .minute], from: UserDetails.notificationTime)
        dayComponents.second = 0
        dayComponents.minute = timeComponents.minute
        dayComponents.hour = timeComponents.hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: dayComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = title + " Vaccination Today"
        content.body = msg
        content.sound = UNNotificationSound.default()
        let notif_identifier = title + " current"
        let request = UNNotificationRequest(identifier: notif_identifier, content: content, trigger: trigger)
        
        
        //schedule new notifications
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Error occured during notification")
            } else {
                
            }
        }
    }
    
    func scheduleDayBeforeNotifications(_ date : Date , _ msg : String , title : String ) {
        let previousDate = gregorian.date(byAdding: .day, value: -1, to: date)
        var dayComponents = Calendar.current.dateComponents([.month,.day,.year], from: previousDate!)
        let timeComponents = Calendar.current.dateComponents([.hour , .minute], from: UserDetails.notificationTime)
        dayComponents.second = 0
        dayComponents.minute = timeComponents.minute
        dayComponents.hour = timeComponents.hour
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dayComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = title + " Vaccination Tommorrow"
        content.body = msg
        content.sound = UNNotificationSound.default()
        let notif_identifier = title + " previous"
        
        let request = UNNotificationRequest(identifier: notif_identifier, content: content, trigger: trigger)
        
        //schedule new notifications
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Error occured during notification")
            } else {
                
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    
    // MARK: - Split view
    
    
}

