// AppDelegate.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "AppDelegate.h"
#import "ViewController.h"
#import "Countly.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CountlyConfig* config = CountlyConfig.new;
    config.appKey = @"YOUR_APP_KEY";
    config.host = @"https://YOUR_COUNTLY_SERVER";
    
//    config.features = @[CLYMessaging, CLYCrashReporting, CLYAPM, CLYAutoViewTracking];     //Optional features

//    config.launchOptions = launchOptions;                         //Required for CLYMessaging feature
//    config.isTestDevice = YES;                                    //Optional marking as test device for CLYMessaging

//    config.crashSegmentation = @{@"SomeOtherSDK":@"v3.4.5"};      //Optional crash segmentation for CLYCrashReporting
    
//    config.deviceID = @"customDeviceID";                          //Optional custom or system generated device ID
//    config.forceDeviceIDInitialization = YES;                     //Optional forcing to re-initialize device ID

//    config.eventSendThreshold = 5;                                //Optional event send threshold (default 10 events)
//    config.updateSessionPeriod = 30;                              //Optional update session period (default 60 seconds)
//    config.storedRequestsLimit = 500;                             //Optional stored requests limit (default 1000 requests)

//    config.ISOCountryCode = @"JP";                                //Optioanl ISO country code
//    config.city = @"Tokyo";                                       //Optional city name
//    config.location = (CLLocationCoordinate2D){35.6895,139.6917}; //Optional location coordinates

//    config.pinnedCertificates = @[@"count.ly.cer"];               //Optional bundled certificates for certificate pinning

//    config.customHeaderFieldName = @"X-My-Custom-Field";          //Optional custom header field name
//    config.customHeaderFieldValue = @"my_custom_value";           //Optional custom header field value

//    config.starRatingMessage = @"Would you rate the app?";        //Optional star-rating dialog message
//    config.starRatingDismissButtonTitle = @"No idea";             //Optional star-rating dialog dismiss button title
//    config.starRatingSessionCount = 3;                            //Optional star-rating dialog auto-ask by session count
//    config.starRatingDisableAskingForEachAppVersion = YES;        //Optional star-rating dialog auto-ask by versions disabling

    [Countly.sharedInstance startWithConfig:config];

    
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    self.viewController = [ViewController.alloc initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings 
{
    [application registerForRemoteNotifications];
}


- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{
    [Countly.sharedInstance didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}


- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
    [Countly.sharedInstance didFailToRegisterForRemoteNotifications];
}


- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler 
{
    if (![Countly.sharedInstance handleRemoteNotification:userInfo])
    {
        
    }
}

@end