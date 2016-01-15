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
//start Countly
//  [Countly.sharedInstance start:@"YOUR_APP_KEY" withHost:@"https://YOUR_API_HOST.com"];
//
//  or use convenience method for Countly Cloud
//
//  [Countly.sharedInstance startOnCloudWithAppKey:@"YOUR_APP_KEY"];
}

- (void)applicationDidBecomeActive
{
//    [Countly.sharedInstance resume];
}

- (void)applicationWillResignActive
{
//    [Countly.sharedInstance suspend];
}

@end
