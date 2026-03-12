// ConsentsViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "ConsentsViewController.h"
#import "Countly.h"

@implementation ConsentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Consents";

    self.tests = @[
        @{@"name": @"Give for Sessions", @"explanation": @""},
        @{@"name": @"Give for Events", @"explanation": @""},
        @{@"name": @"Give for UserDetails", @"explanation": @""},
        @{@"name": @"Give for CrashReporting", @"explanation": @""},
        @{@"name": @"Give for PushNotifications", @"explanation": @""},
        @{@"name": @"Give for Location", @"explanation": @""},
        @{@"name": @"Give for ViewTracking", @"explanation": @""},
        @{@"name": @"Give for Attribution", @"explanation": @""},
        @{@"name": @"Give for Feedback", @"explanation": @""},
        @{@"name": @"Give for PerformanceMonitoring", @"explanation": @""},
        @{@"name": @"Give for RemoteConfig", @"explanation": @""},
        @{@"name": @"Give for Content", @"explanation": @""},
        @{@"name": @"Give for Metrics", @"explanation": @""},
        @{@"name": @"Give for All the Features", @"explanation": @""},
        @{@"name": @"Cancel for Sessions", @"explanation": @""},
        @{@"name": @"Cancel for Events", @"explanation": @""},
        @{@"name": @"Cancel for UserDetails", @"explanation": @""},
        @{@"name": @"Cancel for CrashReporting", @"explanation": @""},
        @{@"name": @"Cancel for PushNotifications", @"explanation": @""},
        @{@"name": @"Cancel for Location", @"explanation": @""},
        @{@"name": @"Cancel for ViewTracking", @"explanation": @""},
        @{@"name": @"Cancel for Attribution", @"explanation": @""},
        @{@"name": @"Cancel for Feedback", @"explanation": @""},
        @{@"name": @"Cancel for PerformanceMonitoring", @"explanation": @""},
        @{@"name": @"Cancel for RemoteConfig", @"explanation": @""},
        @{@"name": @"Cancel for Content", @"explanation": @""},
        @{@"name": @"Cancel for Metrics", @"explanation": @""},
        @{@"name": @"Cancel for All the Features", @"explanation": @""},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:  [Countly.sharedInstance giveConsentForFeature:CLYConsentSessions]; break;
        case 1:  [Countly.sharedInstance giveConsentForFeature:CLYConsentEvents]; break;
        case 2:  [Countly.sharedInstance giveConsentForFeature:CLYConsentUserDetails]; break;
        case 3:  [Countly.sharedInstance giveConsentForFeature:CLYConsentCrashReporting]; break;
        case 4:  [Countly.sharedInstance giveConsentForFeature:CLYConsentPushNotifications]; break;
        case 5:  [Countly.sharedInstance giveConsentForFeature:CLYConsentLocation]; break;
        case 6:  [Countly.sharedInstance giveConsentForFeature:CLYConsentViewTracking]; break;
        case 7:  [Countly.sharedInstance giveConsentForFeature:CLYConsentAttribution]; break;
        case 8:  [Countly.sharedInstance giveConsentForFeature:CLYConsentFeedback]; break;
        case 9:  [Countly.sharedInstance giveConsentForFeature:CLYConsentPerformanceMonitoring]; break;
        case 10: [Countly.sharedInstance giveConsentForFeature:CLYConsentRemoteConfig]; break;
        case 11: [Countly.sharedInstance giveConsentForFeature:CLYConsentContent]; break;
        case 12: [Countly.sharedInstance giveConsentForFeature:CLYConsentMetrics]; break;
        case 13: [Countly.sharedInstance giveAllConsents]; break;
        case 14: [Countly.sharedInstance cancelConsentForFeature:CLYConsentSessions]; break;
        case 15: [Countly.sharedInstance cancelConsentForFeature:CLYConsentEvents]; break;
        case 16: [Countly.sharedInstance cancelConsentForFeature:CLYConsentUserDetails]; break;
        case 17: [Countly.sharedInstance cancelConsentForFeature:CLYConsentCrashReporting]; break;
        case 18: [Countly.sharedInstance cancelConsentForFeature:CLYConsentPushNotifications]; break;
        case 19: [Countly.sharedInstance cancelConsentForFeature:CLYConsentLocation]; break;
        case 20: [Countly.sharedInstance cancelConsentForFeature:CLYConsentViewTracking]; break;
        case 21: [Countly.sharedInstance cancelConsentForFeature:CLYConsentAttribution]; break;
        case 22: [Countly.sharedInstance cancelConsentForFeature:CLYConsentFeedback]; break;
        case 23: [Countly.sharedInstance cancelConsentForFeature:CLYConsentPerformanceMonitoring]; break;
        case 24: [Countly.sharedInstance cancelConsentForFeature:CLYConsentRemoteConfig]; break;
        case 25: [Countly.sharedInstance cancelConsentForFeature:CLYConsentContent]; break;
        case 26: [Countly.sharedInstance cancelConsentForFeature:CLYConsentMetrics]; break;
        case 27: [Countly.sharedInstance cancelConsentForAllFeatures]; break;
        default: break;
    }
}

@end
