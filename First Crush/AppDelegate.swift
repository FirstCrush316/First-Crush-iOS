//
//  AppDelegate.swift
//  First Crush
//
//  Created by Sumit Johri on 10/6/17.
//  Copyright © 2017 Sumit Johri. All rights reserved.
//

import UIKit
import AVFoundation
import OneSignal
import MediaPlayer;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = 0;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
        application.isStatusBarHidden=false
        UINavigationBar.appearance().clipsToBounds = true
        
        //Get Rid of Black Bar under Nav Bar
        UINavigationBar.appearance().shadowImage = UIImage ()
        UINavigationBar.appearance().setBackgroundImage(UIImage(),for: .default)
        //UINavigationBar.appearance().barTintColor = UIColor.black;
        
        //Status Bar Look and Feel
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
            statusBar.backgroundColor = UIColor.black
        }
        
        
        //One Signal Code
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
        
        //Background Play Handling
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
            print("Application State -- Will Resign Active",application.applicationState)
            print ("Background Time Remaining -- Will Resign Active", application.backgroundTimeRemaining)
            print("Background Task Started -- Will Resign Active")
            UIApplication.shared.endBackgroundTask(UIBackgroundTaskInvalid)
            UIApplication.shared.endBackgroundTask(backgroundTask)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        var finished = false
        var count = 30
        backgroundTask = application.beginBackgroundTask(withName:"Radio", expirationHandler: {() -> Void in
            // Time is up.
            print("Application State",application.applicationState)
            print ("Background Time Remaining", application.backgroundTimeRemaining)
            print("Background Task Started",self.backgroundTask)
            if self.backgroundTask != UIBackgroundTaskInvalid {
                // Do something to stop our background task or the app will be killed
                finished = true
            }
        })
        // Perform your background task here
        print("The task has started")
        let appState=UIApplication.shared.applicationState
        print("App State",appState.rawValue)
        while (!finished){
            //DispatchQueue.global(qos:.background).asyncAfter(deadline: .now() + 150) {if count>=0{count=count-1;}
            if (appState == .background){
                sleep(1)
                count=count-1
                print("Not Finished BG Task",count)
                if count<=0 {
                    finished=true
                    print("Finished BG Task",count)
                }
            }
            else {
                finished=true
                print("Non Background Finished",count)
            }
        }
        //DispatchQueue.main.asyncAfter(deadline: .now() + 30) { }// change 2 to desired number of seconds
        application.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid;
        print("Background Task Completed")
    }

    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //it’s important to stop background task when we do not need it anymore
        
        print("Cleaning up inactive background tasks - inside will enter foreground");
        UIApplication.shared.endBackgroundTask(UIBackgroundTaskInvalid)
        UIApplication.shared.endBackgroundTask(backgroundTask)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Cleaning up inactive background tasks - inside Did Become Active");
        UIApplication.shared.endBackgroundTask(UIBackgroundTaskInvalid)
        UIApplication.shared.endBackgroundTask(backgroundTask)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIApplication.shared.endBackgroundTask(UIBackgroundTaskInvalid)
        UIApplication.shared.endBackgroundTask(backgroundTask)
    }
    override func remoteControlReceived(with event: UIEvent?)
    {       print("Remote Event Received")
        switch (event?.subtype) {
        case UIEventSubtype.remoteControlTogglePlayPause?:
            print("Received Headphone Play Pause")
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                return .success
            }
            break;
        case UIEventSubtype.remoteControlPlay?:
            print("Received Remote Play")
            NotificationCenter.default.post(name: NSNotification.Name("playSong"), object: nil)
            MPRemoteCommandCenter.shared().playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                return .success
            }
            break;
        case UIEventSubtype.remoteControlPause?:
            print("Received Remote Pause")
            NotificationCenter.default.post(name: NSNotification.Name("pauseSong"), object: nil)
            MPRemoteCommandCenter.shared().pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                return .success
            }
            break;
        case UIEventSubtype.remoteControlNextTrack?:
            //Handle It
            print("Received Next Event")
            NotificationCenter.default.post(name: NSNotification.Name("nextSong"), object: nil)
            MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                return .success
            }
            break;
        case UIEventSubtype.remoteControlPreviousTrack?:
            //Handle It
            NotificationCenter.default.post(name: NSNotification.Name("previousSong"), object: nil)
            print("Received Previous Event")
            MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                return .success
            }
            break;
        default:
            print("There is an issue with the control")
            break;
        }
    }
}

