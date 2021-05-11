//
//  AppDelegate.swift
//  ThumbnailExample
//
//  Copyright © 2021 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import MoPubSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OguryChoiceManager.shared().setup(withAssetKey: "OGY-5575CC173955"); //Ogury Asset Key
        
        let sdkConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "de5cb2a3b2bc4d5cb6c97a89be556a6f")
        sdkConfig.loggingLevel = .debug
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            print("MoPub initialized")
        }
        return true
    }
}

