//
//  AppDelegate.swift
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import MoPubSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        OguryChoiceManager.shared().setup(withAssetKey: "OGY-5575CC173955"); //Ogury Asset Key
        
        let sdkConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "4a0c441a9c6c4990982c36dfc5e72508")
        sdkConfig.loggingLevel = .debug
        sdkConfig.mediatedNetworkConfigurations = ["OguryAdapterConfiguration":
                                                        ["asset_key": "OGY-5575CC173955"]]


        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            print("MoPub initialized")
        }
        return true
    }
}

