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
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);
    var player:AVPlayer?;
    var playerLayer:AVPlayerLayer?
    var nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    var remoCommandCenter = MPRemoteCommandCenter.shared()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().clipsToBounds = true
        
        //Get Rid of Black Bar under Nav Bar
        UINavigationBar.appearance().shadowImage = UIImage ()
        UINavigationBar.appearance().setBackgroundImage(UIImage(),for: .default)
        //UINavigationBar.appearance().barTintColor = UIColor.black;
        
        //Status Bar Look and Feel - 
        /*let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
            statusBar.backgroundColor = UIColor.black
        }*/
        
        //One Signal Initialization
        // Remove this method to stop OneSignal Debugging
          //OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)

          // OneSignal initialization
          OneSignal.initWithLaunchOptions(launchOptions)
          OneSignal.setAppId("ea063994-c980-468b-8895-fcdd9dd93cf4")

          // promptForPushNotifications will show the native iOS notification permission prompt.
          // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
          OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
          })
        
        //Background Play Handling
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
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
          self.becomeFirstResponder()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
          //self.resignFirstResponder()
        UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier.invalid)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        /*var finished = false
       print("Background Task Started")
        backgroundTask = application.beginBackgroundTask(withName:"Radio", expirationHandler: {() -> Void in
            // Time is up.
            print ("Background Time Remaining -- Will Resign Active in \(application.backgroundTimeRemaining)")
           
            if self.backgroundTask != UIBackgroundTaskInvalid {
                // Do something to stop our background task or the app will be killed
                //Reference https://stackoverflow.com/questions/36684165/how-do-i-keep-my-video-background-to-continuously-play-using-swift
                finished=true
            }
            
            //Ideal Solution from Apple
            if let item = self.player?.currentItem {
                print("Checking for Video")
                print(self.player?.currentItem!.status as Any)
                if item.tracks.first!.assetTrack.hasMediaCharacteristic(AVMediaCharacteristic.visual) {
                    item.tracks.first!.isEnabled = false
                    print("Video Disabled")
                }
            }
            
        })
        
        self.player?.play()
        //Background Handling
       // let count = 30
        let appState=UIApplication.shared.applicationState
        print("App State",appState.rawValue)
        /*while (!finished)
        {
        DispatchQueue.main.async {
            print("Work Dispatched")
            // Do heavy or time consuming work
            
            // Then return the work on the main thread and update the UI
            DispatchQueue.global(qos: .background).asyncAfter(deadline: (.now() + .seconds(count)))
            {
                print("Inside Dispatch 30 Sec Delay")
                print("Dispatch Completed")
                application.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskInvalid;
                print("Background Task Completed")
                finished=true
                
                
            }
        }
        }*/
        /*while (!finished)
        {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: (.now() + .seconds(count)))
                {
                print("Inside Dispatch 30 Sec Delay")
                    print("Dispatch Completed")
                    application.endBackgroundTask(self.backgroundTask)
                    self.backgroundTask = UIBackgroundTaskInvalid;
                    print("Background Task Completed")
                    finished=true
                    
                
                }
        }*/
       
        
        /*while (!finished && appState == .background){
         
                if (appState == .background && {
                    sleep(1)
                    count=count-1
                    print("Not Finished BG Task",count)
                    if count<=0 {
                        finished=true
                        print("Finished BG Task",count)
                        application.endBackgroundTask(self.backgroundTask)
                        self.backgroundTask = UIBackgroundTaskInvalid;
                        print("Background Task Completed")
                    }
                }
                else {
                    finished=true
                    print("Non Background Finished",count)
                }
        }*/
        //let playerItem = AVPlayerItem.
        print("Background Task Complete")
        
        self.backgroundTask = UIBackgroundTaskInvalid;
        UIApplication.shared.endBackgroundTask(UIBackgroundTaskInvalid)*/
    }

    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //it’s important to stop background task when we do not need it anymore
        //Reference https://stackoverflow.com/questions/36684165/how-do-i-keep-my-video-background-to-continuously-play-using-swift
        /*if let item = self.player?.currentItem {
            if item.tracks.first!.assetTrack.hasMediaCharacteristic(AVMediaCharacteristic.visual) {
                item.tracks.first!.isEnabled = true
                print("Video Enabled")
            }
        }*/
        self.becomeFirstResponder();
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.becomeFirstResponder();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier.invalid)
        self.resignFirstResponder()
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
