// RemoteConfigViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "RemoteConfigViewController.h"
#import "Countly.h"
#import "CountlyExperimentInformation.h"

static RCDownloadCallback rcCallback1;
static RCDownloadCallback rcCallback2;
static RCDownloadCallback rcCallback3;

@implementation RemoteConfigViewController

+ (void)initialize
{
    if (self == [RemoteConfigViewController class])
    {
        rcCallback1 = ^(CLYRequestResult response, NSError *error, BOOL fullValueUpdate, NSDictionary *downloadedValues) {
            printf("remoteConfigLocalCallback rcCallback 1");
        };
        rcCallback2 = ^(CLYRequestResult response, NSError *error, BOOL fullValueUpdate, NSDictionary *downloadedValues) {
            printf("remoteConfigLocalCallback rcCallback 2");
        };
        rcCallback3 = ^(CLYRequestResult response, NSError *error, BOOL fullValueUpdate, NSDictionary *downloadedValues) {
            printf("remoteConfigLocalCallback rcCallback 3");
        };
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Remote Config";

    self.tests = @[
        @{@"name": @"Register RC callback 1", @"explanation": @""},
        @{@"name": @"Register RC callback 2", @"explanation": @""},
        @{@"name": @"Register RC callback 3", @"explanation": @""},
        @{@"name": @"Remove RC callback 1", @"explanation": @""},
        @{@"name": @"Remove RC callback 2", @"explanation": @""},
        @{@"name": @"Remove RC callback 3", @"explanation": @""},
        @{@"name": @"Download RC", @"explanation": @"for all keys"},
        @{@"name": @"Download RC (keys)", @"explanation": @"for 'rc_1' key"},
        @{@"name": @"Download RC (omit keys)", @"explanation": @"omitting 'ab_1' key"},
        @{@"name": @"Get RC", @"explanation": @"get all RC values"},
        @{@"name": @"Get RC (key)", @"explanation": @"for 'rc_1' key"},
        @{@"name": @"Clear RC", @"explanation": @"clear all RC values"},
        @{@"name": @"AB enroll (keys)", @"explanation": @"for 'ab_1' key"},
        @{@"name": @"AB exit (keys)", @"explanation": @"for 'ab_1' key"},
        @{@"name": @"Download Variants", @"explanation": @"download all variants"},
        @{@"name": @"Get Variants", @"explanation": @"get all variants"},
        @{@"name": @"Get Variant", @"explanation": @"for 'ab_1' key"},
        @{@"name": @"AB enroll (variant)", @"explanation": @"for key: 'ab_1' and name: 'Variant B'"},
        @{@"name": @"Get Value and Enroll", @"explanation": @"for 'rc_1' key"},
        @{@"name": @"Get All Values and Enroll", @"explanation": @""},
        @{@"name": @"Download Experiment Info", @"explanation": @"download experiment information"},
        @{@"name": @"Get All Experiment Info", @"explanation": @""},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: [Countly.sharedInstance.remoteConfig registerDownloadCallback:rcCallback1]; break;
        case 1: [Countly.sharedInstance.remoteConfig registerDownloadCallback:rcCallback2]; break;
        case 2: [Countly.sharedInstance.remoteConfig registerDownloadCallback:rcCallback3]; break;
        case 3: [Countly.sharedInstance.remoteConfig removeDownloadCallback:rcCallback1]; break;
        case 4: [Countly.sharedInstance.remoteConfig removeDownloadCallback:rcCallback2]; break;
        case 5: [Countly.sharedInstance.remoteConfig removeDownloadCallback:rcCallback3]; break;

        case 6:
        {
            [Countly.sharedInstance.remoteConfig downloadKeys:^(CLYRequestResult response, NSError *error, BOOL fullValueUpdate, NSDictionary<NSString *, CountlyRCData *> *downloadedValues) {
                if (response == CLYResponseSuccess) NSLog(@"Download RC is successful. \n%@", downloadedValues);
                else NSLog(@"Download RC failed: %@", error);
            }];
        } break;

        case 7:
        {
            [Countly.sharedInstance.remoteConfig downloadSpecificKeys:@[@"rc_1"] completionHandler:^(CLYRequestResult response, NSError *error, BOOL fullValueUpdate, NSDictionary<NSString *, CountlyRCData *> *downloadedValues) {
                if (response == CLYResponseSuccess) NSLog(@"Download RC is successful. \n%@", downloadedValues);
                else NSLog(@"Download RC failed: %@", error);
            }];
        } break;

        case 8:
        {
            [Countly.sharedInstance.remoteConfig downloadOmittingKeys:@[@"ab_1"] completionHandler:^(CLYRequestResult response, NSError *error, BOOL fullValueUpdate, NSDictionary<NSString *, CountlyRCData *> *downloadedValues) {
                if (response == CLYResponseSuccess) NSLog(@"Download RC is successful. \n%@", downloadedValues);
                else NSLog(@"Download RC failed: %@", error);
            }];
        } break;

        case 9:
        {
            NSDictionary<NSString *, CountlyRCData *> *rCValues = [Countly.sharedInstance.remoteConfig getAllValues];
            NSLog(@"Get all RC is successful. \n%@", rCValues);
        } break;

        case 10:
        {
            CountlyRCData *rCValue = [Countly.sharedInstance.remoteConfig getValue:@"rc_1"];
            NSLog(@"Get RC for key 'rc_1' is successful. \n%@", rCValue);
        } break;

        case 11: [Countly.sharedInstance.remoteConfig clearAll]; break;
        case 12: [Countly.sharedInstance.remoteConfig enrollIntoABTestsForKeys:@[@"ab_1"]]; break;
        case 13: [Countly.sharedInstance.remoteConfig exitABTestsForKeys:@[@"ab_1"]]; break;

        case 14:
        {
            [Countly.sharedInstance.remoteConfig testingDownloadVariantInformation:^(CLYRequestResult response, NSError *error) {
                if (response == CLYResponseSuccess) NSLog(@"testingDownloadVariantInformation is successful.");
                else NSLog(@"testingDownloadVariantInformation failed: %@", error);
            }];
        } break;

        case 15:
        {
            NSDictionary *variants = [Countly.sharedInstance.remoteConfig testingGetAllVariants];
            NSLog(@"testingGetAllVariants is successful. \n%@", variants);
        } break;

        case 16:
        {
            NSArray *variant = [Countly.sharedInstance.remoteConfig testingGetVariantsForKey:@"ab_1"];
            NSLog(@"testingGetVariantsForKey is successful. \n%@", variant);
        } break;

        case 17:
        {
            [Countly.sharedInstance.remoteConfig testingEnrollIntoVariant:@"ab_1" variantName:@"Variant B" completionHandler:^(CLYRequestResult response, NSError *error) {
                if (response == CLYResponseSuccess) NSLog(@"testingEnrollIntoVariant is successful.");
                else NSLog(@"testingEnrollIntoVariant failed: %@", error);
            }];
        } break;

        case 18:
        {
            CountlyRCData *rCValue = [Countly.sharedInstance.remoteConfig getValueAndEnroll:@"rc_1"];
            NSLog(@"getValueAndEnroll for key 'rc_1': %@", rCValue);
        } break;

        case 19:
        {
            NSDictionary<NSString *, CountlyRCData *> *rCValues = [Countly.sharedInstance.remoteConfig getAllValuesAndEnroll];
            NSLog(@"getAllValuesAndEnroll: %@", rCValues);
        } break;

        case 20:
        {
            [Countly.sharedInstance.remoteConfig testingDownloadExperimentInformation:^(CLYRequestResult response, NSError *error) {
                if (response == CLYResponseSuccess) NSLog(@"testingDownloadExperimentInformation is successful.");
                else NSLog(@"testingDownloadExperimentInformation failed: %@", error);
            }];
        } break;

        case 21:
        {
            NSDictionary<NSString *, CountlyExperimentInformation *> *experiments = [Countly.sharedInstance.remoteConfig testingGetAllExperimentInfo];
            NSLog(@"testingGetAllExperimentInfo: %@", experiments);
        } break;

        default: break;
    }
}

@end
