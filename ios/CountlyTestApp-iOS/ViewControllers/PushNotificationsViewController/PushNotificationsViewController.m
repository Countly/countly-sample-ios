// PushNotificationsViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "PushNotificationsViewController.h"
#import "Countly.h"

@implementation PushNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Push Notifications";

    self.tests = @[
        @{@"name": @"Ask for Notification Permission", @"explanation": @""},
        @{@"name": @"Ask for Notification Permission with Completion Handler", @"explanation": @""},
        @{@"name": @"Record Push Notification Action", @"explanation": @"for manually handled push notifications"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: [Countly.sharedInstance askForNotificationPermission]; break;

        case 1:
        {
            UNAuthorizationOptions authorizationOptions = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
            [Countly.sharedInstance askForNotificationPermissionWithOptions:authorizationOptions completionHandler:^(BOOL granted, NSError *error) {
                NSLog(@"Notification Permission Granted: %d", granted);
                NSLog(@"Error: %@", error);
            }];
        } break;

        case 2:
        {
            NSDictionary *userInfo = NSDictionary.new;
            NSInteger buttonIndex = 1;
            [Countly.sharedInstance recordActionForNotification:userInfo clickedButtonIndex:buttonIndex];
        } break;

        default: break;
    }
}

@end
