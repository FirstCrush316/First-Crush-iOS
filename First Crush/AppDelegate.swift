//
//  AppDelegate.swift
//  First Crush
//
//  Created by Sumit Johri on 10/6/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.
//

import UIKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarStyle = .lightContent
        application.isStatusBarHidden=true
        UIApplication.shared.keyWindow?.backgroundColor = UIColor.black
        //UINavigationBar.appearance().clipsToBounds = true
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true]
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "ea063994-c980-468b-8895-fcdd9dd93cf4",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
        
        print("Received Notification: \(notification!.payload.notificationID)")
    }
    
    let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
        // This block gets called when the user reacts to a notification received
        let payload: OSNotificationPayload = result!.notification.payload
        
        var fullMessage = payload.body
        print("Message = \(String(describing: fullMessage))")
        
        if payload.additionalData != nil {
            if payload.title != nil {
                let messageTitle = payload.title
                print("Message Title = \(messageTitle!)")
            }
            
            let additionalData = payload.additionalData
            if additionalData?["actionSelected"] != nil {
                fullMessage = fullMessage! + "\nPressed ButtonID: \(String(describing: additionalData!["actionSelected"]))"
            }
        }
    }
    
   
    OneSignal.initWithLaunchOptions(launchOptions,appId: "ea063994-c980-468b-8895-fcdd9dd93cf4",handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
    
    OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
    
            return true
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


}

