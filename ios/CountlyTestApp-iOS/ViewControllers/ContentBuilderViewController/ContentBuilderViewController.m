// ContentBuilderViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "ContentBuilderViewController.h"
#import "Countly.h"

@implementation ContentBuilderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Content Builder";

    self.tests = @[
        @{@"name": @"Enter Content Zone", @"explanation": @""},
        @{@"name": @"Exit Content Zone", @"explanation": @""},
        @{@"name": @"Refresh Content Zone", @"explanation": @""},
        @{@"name": @"Change Device ID", @"explanation": @"Change ID and give all consents"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: [Countly.sharedInstance.content enterContentZone]; break;
        case 1: [Countly.sharedInstance.content exitContentZone]; break;
        case 2: [Countly.sharedInstance.content refreshContentZone]; break;
        case 3:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Device ID"
                                                                           message:@"Enter new device ID"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"new_device_id";
            }];

            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSString *newID = alert.textFields.firstObject.text;
                if (newID.length > 0)
                {
                    [Countly.sharedInstance setID:newID];
                    [Countly.sharedInstance giveAllConsents];
                    NSLog(@"Device ID changed to: %@ and all consents given", newID);
                }
            }]];

            [self presentViewController:alert animated:YES completion:nil];
        } break;

        default: break;
    }
}

@end
