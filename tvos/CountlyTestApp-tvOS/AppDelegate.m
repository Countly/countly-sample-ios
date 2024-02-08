// AppDelegate.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "AppDelegate.h"
#import "Countly.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CountlyConfig* config = CountlyConfig.new;
    config.appKey = @"YOUR_APP_KEY";
    config.host = @"https://your.server.ly";
    config.enableDebug = YES;

    if ([config.appKey isEqualToString:@"YOUR_APP_KEY"] || [config.host isEqualToString:@"https://your.server.ly"]) {
        NSLog(@"Please do not use default set of app key and server url");
    }
    
//  config.deviceID = @"customDeviceID"                               //Optional custom or system generated device ID
//  config.features = @[CLYCrashReporting, CLYAutoViewTracking];                                      //Optional features
    [Countly.sharedInstance startWithConfig:config];

    return YES;
}

@end
