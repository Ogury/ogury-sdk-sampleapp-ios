//
//  AppDelegate.swift
//  Direct Integration Sample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryAds
import OguryChoiceManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //SDK setup
        OguryChoiceManager.shared().setup(withAssetKey: ConstantKeys.assetKey)
        OguryAds.shared().setup(withAssetKey: ConstantKeys.assetKey, andCompletionHandler: { error in
            if let error = error {
                print("[Ads][SetUp]Error :\(error.localizedDescription)")
            } else {
                print("[Ads][SetUp] success")
            }
        })

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

