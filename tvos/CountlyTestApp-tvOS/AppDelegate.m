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
//start Countly
//  [Countly.sharedInstance start:@"YOUR_APP_KEY" withHost:@"https://YOUR_API_HOST.com"];
//
//or use convenience method for Countly Cloud
//
//  [Countly.sharedInstance startOnCloudWithAppKey:@"YOUR_APP_KEY"];

    return YES;
}

@end