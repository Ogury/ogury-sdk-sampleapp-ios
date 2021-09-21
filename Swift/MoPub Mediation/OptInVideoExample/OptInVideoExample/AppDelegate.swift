//
//  AppDelegate.swift
//  OptinVideoExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import MoPubSDK
import OguryChoiceManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OguryChoiceManager.shared().setup(withAssetKey: "OGY-5575CC173955"); //Ogury Asset Key
        
        let sdkConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "ebfc19b6252649ef9f77520a5ac85531")
        sdkConfig.loggingLevel = .debug
        sdkConfig.mediatedNetworkConfigurations = ["OguryAdapterConfiguration":
                                                        ["asset_key": "OGY-5575CC173955"]]
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            print("MoPub initialized")
        }
        return true
    }
}
