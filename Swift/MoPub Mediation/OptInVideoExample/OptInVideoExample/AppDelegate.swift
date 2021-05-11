//
//  AppDelegate.swift
//  OptinVideoExample
//
//  Copyright © 2021 Ogury Co. All rights reserved.
//

import UIKit
import MoPubSDK
import OguryChoiceManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OguryChoiceManager.shared().setup(withAssetKey: "OGY-5575CC173955"); //Ogury Asset Key
        
        let sdkConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "ef93d42cfed24a23b76091f5ecb5c871")
        sdkConfig.loggingLevel = .debug
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            print("MoPub initialized")
        }
        return true
    }
}
