// AppDelegate.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TestModalViewController.h"
#import "Countly.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CountlyConfig* config = CountlyConfig.new;
    config.appKey = @"YOUR_APP_KEY";
    config.host = @"https://YOUR_COUNTLY_SERVER";
    config.enableDebug = YES;

//    config.features = @[CLYPushNotifications, CLYCrashReporting, CLYAutoViewTracking];     //Optional features

//    config.requiresConsent = YES;                                 //Optional consents

//    config.isTestDevice = YES;                                    //Optional marking as test device for CLYPushNotifications
//    config.sendPushTokenAlways = YES;                             //Optional forcing to send token always
//    config.doNotShowAlertForNotifications = YES;                  //Optional disabling alerts shown by notification
//    config.location = (CLLocationCoordinate2D){35.6895,139.6917}; //Optional location for geo-location push
//    config.city = @"Tokyo";                                       //Optional city name for geo-location push
//    config.ISOCountryCode = @"JP";                                //Optional ISO country code for geo-location push
//    config.IP = @"128.0.0.1";                                     //Optional IP address for geo-location push

//    config.deviceID = @"customDeviceID";                          //Optional custom or system generated device ID
//    config.forceDeviceIDInitialization = YES;                     //Optional forcing to re-initialize device ID
//    config.applyZeroIDFAFix = YES;                                //Optional Zero-IDFA fix

//    config.updateSessionPeriod = 30;                              //Optional update session period (default 60 seconds)
//    config.manualSessionHandling = YES;                           //Optional manual session handling

//    config.eventSendThreshold = 5;                                //Optional event send threshold (default 10 events)
//    config.storedRequestsLimit = 500;                             //Optional stored requests limit (default 1000 requests)
//    config.alwaysUsePOST = YES;                                   //Optional forcing for POST method

//    config.enableAppleWatch = YES;                                //Optional Apple Watch related features
//    config.enableAttribution = YES;                               //Optional attribution

//    config.crashSegmentation = @{@"SomeOtherSDK":@"v3.4.5"};      //Optional crash segmentation for CLYCrashReporting
//    config.crashLogLimit = 5;                                     //Optional crash log limiy

//    config.pinnedCertificates = @[@"count.ly.cer"];               //Optional bundled certificates for certificate pinning
//    config.customHeaderFieldName = @"X-My-Custom-Field";          //Optional custom header field name
//    config.customHeaderFieldValue = @"my_custom_value";           //Optional custom header field value
//    config.secretSalt = @"secretsalt"                             //Optional salt for parameter tampering protection

//    config.starRatingMessage = @"Would you rate the app?";        //Optional star-rating dialog message
//    config.starRatingSessionCount = 3;                            //Optional star-rating dialog auto-ask by session count
//    config.starRatingDisableAskingForEachAppVersion = YES;        //Optional star-rating dialog auto-ask by versions disabling
//    config.starRatingCompletion = ^(NSInteger rating){ NSLog(@"rating %d",(int)rating); };        //Optional star-rating dialog auto-ask completion block

//    config.enableRemoteConfig = YES;                              //Optional Remote Config
//    config.remoteConfigCompletionHandler = ^(NSError * error)     //Optional Remote Config completion handler
//    {
//        if (!error)
//        {
//            NSLog(@"Remote Config is ready to use!");
//        }
//        else
//        {
//            NSLog(@"There is an error while fetching Remote Config:\n%@", error);
//        }
//    };

    [Countly.sharedInstance startWithConfig:config];


    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
    self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.window makeKeyAndVisible];

    return YES;
}

//NOTE: Deeplinking example
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if ([url.scheme isEqualToString: @"countly"])
    {
        NSString* product = url.host;
    
        if ([product isEqualToString: @"productA"] || [product isEqualToString: @"productB"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
            TestModalViewController* tmvc = [storyboard instantiateViewControllerWithIdentifier:@"TestModalViewController"];
            tmvc.title = [@"Page of " stringByAppendingString:product];
            [self.window.rootViewController presentViewController:tmvc animated:YES completion:nil];
        }
    }

    return YES;
}

@end
