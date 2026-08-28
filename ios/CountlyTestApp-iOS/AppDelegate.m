// AppDelegate.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TestModalViewController.h"
#import "Countly.h"

// Parity scenarios drive the SDK directly, so the same run can be captured from
// both sample applications and the two captures diffed. See Tools/parity/SCENARIOS.md.
@interface AppDelegate (CountlyScenarios)
- (void)runScenario;
@end

NSString* CountlyScenarioName(void);
void CountlyScenarioConfigure(CountlyConfig* config, NSString* scenario);

@implementation AppDelegate

- (void)internalLog:(nonnull NSString *)log withLevel:(CLYInternalLogLevel)level {
    NSLog(@"Countly internalLog : %@", log);
}
RCDownloadCallback rcGlobalCallback = ^(CLYRequestResult response, NSError * error, BOOL fullValueUpdate, NSDictionary* downloadedValues)
{
    NSLog(@"remoteConfigCallback rcGlobalCallback");
};

RCDownloadCallback rcCallback = ^(CLYRequestResult response, NSError * error, BOOL fullValueUpdate, NSDictionary* downloadedValues)
{
    NSLog(@"remoteConfigCallback rcCallback");
};

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CountlyConfig* config = CountlyConfig.new;
    config.enableDebug = YES;
    config.features = @[CLYCrashReporting, CLYPushNotifications];
    config.sendPushTokenAlways = YES;
    config.appKey = @"APP_KEY";
    config.host = @"https://SERVER_URL";
    config.pushTestMode = CLYPushTestModeDevelopment;
    config.alwaysUsePOST = YES;
    [config.content setWebviewDisplayOption:IMMERSIVE];
    config.enableRemoteConfig = YES;
    config.enableRemoteConfigAutomaticTriggers = YES;
    // No remote config, no APM, no auto view tracking, no attribution.

    // ===== ORIGINAL CONFIG (revert by uncommenting and removing block above) =====
    // config.features = @[CLYCrashReporting, CLYPushNotifications];
    // config.sendPushTokenAlways = YES;
    // config.appKey = @"dte_web";
    // config.host = @"https://master.count.ly";
    // config.pushTestMode = CLYPushTestModeDevelopment;
    // config.alwaysUsePOST = YES;
    // config.requiresConsent = YES;
    //config.city = @"Moscow";
    //config.ISOCountryCode = @"RU";
    [config.content setWebviewDisplayOption:SAFE_AREA];
    //[config.content setContentURLHandler:^BOOL(NSURL * _Nonnull url) {
    //    __block BOOL Val = YES;
    //    TestModalViewController *customVC = [[TestModalViewController alloc] init];
    //    SceneDelegate *mySceneDelegate = [self getActiveSceneDelegate];                    // 4. Find the root view controller to present from
    //    if(mySceneDelegate){
    //        UIViewController *rootViewController = mySceneDelegate.window.rootViewController;
    //
    //        // If the root is a navigation controller, you might want to push it instead:
    //         [(UINavigationController *)rootViewController pushViewController:customVC animated:YES];
    //
    //        // Otherwise, present it modally:
    //        //[rootViewController presentViewController:customVC animated:YES completion:nil];
    //    }

    //    return Val;
    //}];
    //fund-intent


    if ([config.appKey isEqualToString:@"YOUR_APP_KEY"] || [config.host isEqualToString:@"https://your.server.ly"]) {
        NSLog(@"Please do not use default set of app key and server url");
    }

//    config.features = @[CLYPushNotifications, CLYCrashReporting, CLYAutoViewTracking];     //Optional features
//    config.pushTestMode = CLYPushTestModeDevelopment;
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

    config.enableRemoteConfigValueCaching = YES;
    config.enableRemoteConfigAutomaticTriggers = YES;
    [config remoteConfigRegisterGlobalCallback:rcGlobalCallback];

    if ([NSUserDefaults.standardUserDefaults stringForKey:@"CountlyScenario"])
    {
        CountlyScenarioConfigure(config, CountlyScenarioName());
    }

    [Countly.sharedInstance startWithConfig:config];

    if ([NSUserDefaults.standardUserDefaults stringForKey:@"CountlyScenario"])
    {
        // Delayed so init has finished and its own requests have left, which is
        // where each scenario's own traffic starts.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self runScenario];
        });
    }
    
    [Countly.sharedInstance.remoteConfig registerDownloadCallback:rcCallback];
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
            [self.window.rootViewController addChildViewController:tmvc];
            [self.window.rootViewController.view addSubview:tmvc.view];
        }
    }

    return YES;
}

@end
