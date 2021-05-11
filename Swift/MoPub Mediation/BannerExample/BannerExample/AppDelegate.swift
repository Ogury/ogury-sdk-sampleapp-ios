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

        let sdkConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "7e2bf143b2c0470fab647c0868571370")
        sdkConfig.loggingLevel = .debug
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            print("MoPub initialized")
        }
        return true
    }



}

