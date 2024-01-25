// ExtensionDelegate.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "ExtensionDelegate.h"
#import "Countly.h"

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching
{
    CountlyConfig* config = CountlyConfig.new;
    config.appKey = @"YOUR_APP_KEY";
    config.host = @"https://your.server.ly";
    config.enableDebug = YES;
    
    if ([config.appKey isEqualToString:@"YOUR_APP_KEY"] || [config.host isEqualToString:@"https://your.server.ly"]) {
        NSLog(@"Please do not use default set of app key and server url");
        exit(0);
    }

//  config.deviceID = @"customDeviceID"                               //Optional custom or system generated device ID
//  config.features = @[CLYAPM];                                      //Optional features
    [Countly.sharedInstance startWithConfig:config];
}

- (void)applicationDidBecomeActive
{
    [Countly.sharedInstance resume];
}

- (void)applicationWillResignActive
{
    [Countly.sharedInstance suspend];
}

@end
