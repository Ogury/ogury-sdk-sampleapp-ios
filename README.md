# Ogury Integrations Sample Apps

Here you can find integration samples for Ogury Ads and Ogury Choice Manager SDKs.

## Available Sample Apps
Direct Integration:
- [x] Interstitial
- [x] Opt-In Video
- [x] Thumbnail
- [x] Banner & MPU

Google AdMob Integration:
- [x] Interstitial
- [x] Opt-In Video
- [x] Thumbnail
- [x] Banner


## Requirements
- iOS 15.0+
- Xcode 13+

## Installation

_**CocoaPods** is a dependency manager for Cocoa projects and it's required for this project. For usage and installation instructions, visit [their official documentation](https://guides.cocoapods.org/)._

1. Install the cocoapods dependecy to the project by running bellow command using terminal in root folder of desired language:
 	 - [Swift](https://github.com/Ogury/ogury-sdk-sampleapp-ios/tree/master/Swift "Swift")
	 - [Objective C](https://github.com/Ogury/ogury-sdk-sampleapp-ios/tree/master/Objective%20C "Objective C")
   
   <br/>
   
   ```
    pod install
   ```

2. Open the `(Swift|Objective C) sample.xcworkspace`.

3. In your workspace, choose the corresponding integration sample schema:

   <img src="images/changeSchema.png"  width="400">

   _For mediation integrations, some additional configuration may be required, check our documentation [here](https://docs.ogury.co/)._


4. (Optional) Use your own keys/ad units: 

    - Replace the bundle identifler in your project target
    - Replace constants inside the Constants.swift or Constant.m file

## Documentation
For a complete documentation for Ogury Choice Manager and each type of ad please visit [https://docs.ogury.co](https://docs.ogury.co)

## Release Notes
Release notes for Ogury SDK can be found at : [https://docs.ogury.co/release-notes/ios](https://docs.ogury.co/release-notes/ios)

## Support
If you need help please checkout [https://help.publishers.ogury.co/hc/en-us](https://help.publishers.ogury.co/hc/en-us)
