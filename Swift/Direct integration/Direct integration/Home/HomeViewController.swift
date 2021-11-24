//
//  HomeViewController.swift
//  Direct Integration Sample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryAds
import OguryChoiceManager

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var versionLabel: UILabel!

    override func viewDidLoad() {
        // Add tap gesture recognizer to View
        self.versionLabel.text = "OguryAds version:\(OguryAds.shared().sdkVersion ?? "Error")\nChoice Manager version: \(OguryChoiceManager.shared().consentSDKVersion())"
    }
}
