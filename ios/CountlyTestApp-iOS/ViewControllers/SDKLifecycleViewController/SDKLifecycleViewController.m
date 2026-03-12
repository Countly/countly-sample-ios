// SDKLifecycleViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "SDKLifecycleViewController.h"
#import "DeviceIdChangerViewController.h"
#import "Countly.h"

@implementation SDKLifecycleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"SDK Lifecycle";

    self.tests = @[
        @{@"name": @"Halt SDK", @"explanation": @"Reset SDK state"},
        @{@"name": @"Halt SDK (clear storage)", @"explanation": @"Reset SDK state and clear storage"},
        @{@"name": @"Set New Host", @"explanation": @"https://new.server.ly"},
        @{@"name": @"Set New App Key", @"explanation": @"new_app_key"},
        @{@"name": @"Set New URL Session Configuration", @"explanation": @"Default configuration"},
        @{@"name": @"Get Device ID", @"explanation": @"Log current device ID"},
        @{@"name": @"Get Device ID Type", @"explanation": @"Log current device ID type"},
        @{@"name": @"Change Device ID With Merge", @"explanation": @"merged_device_id"},
        @{@"name": @"Change Device ID Without Merge", @"explanation": @"user@example.com"},
        @{@"name": @"Enable Temporary Device ID Mode", @"explanation": @""},
        @{@"name": @"Open Device ID Changer", @"explanation": @"Interactive device ID change"},
        @{@"name": @"Begin Session", @"explanation": @"manual session handling"},
        @{@"name": @"Update Session", @"explanation": @"manual session handling"},
        @{@"name": @"End Session", @"explanation": @"manual session handling"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: [Countly.sharedInstance halt]; break;
        case 1: [Countly.sharedInstance halt:YES]; break;
        case 2: [Countly.sharedInstance setNewHost:@"https://new.server.ly"]; break;
        case 3: [Countly.sharedInstance setNewAppKey:@"new_app_key"]; break;
        case 4: [Countly.sharedInstance setNewURLSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; break;

        case 5: NSLog(@"Device ID: %@", [Countly.sharedInstance deviceID]); break;
        case 6: NSLog(@"Device ID Type: %@", [Countly.sharedInstance deviceIDType]); break;

        case 7: [Countly.sharedInstance changeDeviceIDWithMerge:@"merged_device_id"]; break;
        case 8: [Countly.sharedInstance changeDeviceIDWithoutMerge:@"user@example.com"]; break;
        case 9: [Countly.sharedInstance enableTemporaryDeviceIDMode]; break;

        case 10:
        {
            DeviceIdChangerViewController *controller = [DeviceIdChangerViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        } break;

        case 11: [Countly.sharedInstance beginSession]; break;
        case 12: [Countly.sharedInstance updateSession]; break;
        case 13: [Countly.sharedInstance endSession]; break;

        default: break;
    }
}

@end
