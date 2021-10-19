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
        OguryChoiceManager.shared().setup(withAssetKey: "asset_key"); //Ogury Asset Key

        let sdkConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "mopub_adunit")
        sdkConfig.loggingLevel = .debug
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            print("MoPub initialized")
        }
        return true
    }



}

