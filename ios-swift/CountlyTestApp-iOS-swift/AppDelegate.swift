//  AppDelegate.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let config: CountlyConfig = CountlyConfig()
        config.appKey = "YOUR_APP_KEY"
        config.host = "https://YOUR_COUNTLY_SERVER"
        config.enableDebug = true

//      config.features = [CLYPushNotifications, CLYCrashReporting, CLYAutoViewTracking] //Optional features

//      config.launchOptions = launchOptions                            //Prior to v16.10 was required for CLYPushNotifications
//      config.isTestDevice = true                                      //Optional marking as test device for CLYPushNotifications
//      config.sendPushTokenAlways = ture                               //Optional forcing to send token always
//      config.doNotShowAlertForNotifications = true                    //Optional disabling alerts shown by notification

//      config.crashSegmentation = ["SomeOtherSDK":"v3.4.5"];           //Optional crash segmentation for CLYCrashReporting

//      config.deviceID = "customDeviceID"                              //Optional custom or system generated device ID
//      config.forceDeviceIDInitialization = true                       //Optional forcing to re-initialize device ID

//      config.eventSendThreshold = 5                                   //Optional event send threshold (default 10 events)
//      config.manualSessionHandling = true                             //Optional manual session handling
//      config.updateSessionPeriod = 30                                 //Optional update session period (default 60 seconds)
//      config.storedRequestsLimit = 500                                //Optional stored requests limit (default 1000 requests)
//      config.alwaysUsePOST = true                                     //Optional forcing for POST method

//      config.enableAppleWatch = true                                  //Optional Apple Watch related features

//      config.applyZeroIDFAFix = true                                  //Optional Zero-IDFA fix

//      config.enableAppleWatch = true                                  //Optional Apple Watch related features
//      config.isoCountryCode = "JP"                                    //Optional ISO country code
//      config.city = "Tokyo"                                           //Optional city name
//      config.location = CLLocationCoordinate2D(latitude:35.6895, longitude: 139.6917) //Optional location coordinates
//      config.IP = "128.0.0.1"                                         //Optional IP address

//      config.pinnedCertificates = ["count.ly.cer"]                    //Optional bundled certificates for certificate pinning
//      config.customHeaderFieldName = "X-My-Custom-Field"              //Optional custom header field name
//      config.customHeaderFieldValue = "my_custom_value"               //Optional custom header field value
//      config.secretSalt = "secretsalt"                                //Optional salt for parameter tampering protection

//      config.starRatingMessage = "Would you rate the app?"            //Optional star-rating dialog message
//      config.starRatingDismissButtonTitle = "No idea"                 //Optional star-rating dialog dismiss button title
//      config.starRatingSessionCount = 3                               //Optional star-rating dialog auto-ask by session count
//      config.starRatingDisableAskingForEachAppVersion = true          //Optional star-rating dialog auto-ask by versions disabling
//      config.starRatingCompletion = { (rating : Int) in print("rating \(rating)") }

        Countly.sharedInstance().start(with: config)
    
        return true
    }
}
