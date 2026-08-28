// ContentBuilderViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "ContentBuilderViewController.h"
#import "Countly.h"
#import "CountlyWebViewManager.h"

// TEB support repro: load their exact journey-content URL directly through the
// SDK's WebView pipeline (critical-resource detection included). No session/event
// traffic is sent — the only request is this content GET, which already carries
// TEB's app_user_id/uid, so it reads as the real user and adds nothing to their analytics.
static NSString *const kTEBContentURL =
    @"https://countly.teb.com.tr/_external/content"
     "?app_id=63d3c92832b8b4bd3f6e68cd"
     "&app_user_id=67281e6f39f54d1376c0fc6710b52aed94aadf3e"
     "&id=67a0a541b9809ea4b09a6fd4"
     "&uid=60i"
     "&la=tr"
     "&journeyDefinitionId=69788127d3011e49742ee117"
     "&journeyId=69788127d3011e49742ee118"
     "&blockId=block_2"
     "&journeyInstanceId=6a35412431e3d18700cb3bd3";

@interface ContentBuilderViewController ()
@property (nonatomic, strong) CountlyWebViewManager *tebReproManager;
@end

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
        @{@"name": @"Load TEB Content URL (repro)", @"explanation": @"Loads TEB's exact journey-content URL via the SDK WebView pipeline"},
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

        case 4:
        {
            NSURL *url = [NSURL URLWithString:kTEBContentURL];
            CGRect frame = UIScreen.mainScreen.bounds;
            NSLog(@"[TEB repro] Loading content URL: %@", url.absoluteString);

            self.tebReproManager = [CountlyWebViewManager new];
            [self.tebReproManager createWebViewWithURL:url
                                                 frame:frame
                                           appearBlock:^{
                NSLog(@"[TEB repro] appearBlock fired — content WebView appeared (NOT closed by critical-resource detection)");
            }
                                          dismissBlock:^{
                NSLog(@"[TEB repro] dismissBlock fired — content WebView dismissed/closed");
            }];
        } break;

        default: break;
    }
}

@end
