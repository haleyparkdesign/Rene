//
//  AppDelegate.swift
//  Rene
//
//  Created by Hyojeong Park on 11/6/19.
//  Copyright © 2019 Haley Park. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    // unsupported device error message screen
//    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//         if !ARFaceTrackingConfiguration.isSupported {
//             /*
//              Shipping apps cannot require a face-tracking-compatible device, and thus must
//              offer face tracking AR as a secondary feature. In a shipping app, use the
//              `isSupported` property to determine whether to offer face tracking AR features.
//              This sample code has no features other than a demo of ARKit face tracking, so
//              it replaces the AR view (the initial storyboard in the view controller) with
//              an alternate view controller containing a static error message.
//              */
//             let storyboard = UIStoryboard(name: "Main", bundle: nil)
//             window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "unsupportedDeviceMessage")
//         }
//         return true
//     }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

