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

        let sdkConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "b5cabe32c7f741d687d411d5f45ec4e6")
        sdkConfig.loggingLevel = .debug
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            print("MoPub initialized")
        }
        return true
    }



}

