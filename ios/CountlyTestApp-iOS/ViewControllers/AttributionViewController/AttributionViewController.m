// AttributionViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "AttributionViewController.h"
#import "Countly.h"

@implementation AttributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Attribution";

    self.tests = @[
        @{@"name": @"Record Direct Attribution", @"explanation": @"campaignType: countly"},
        @{@"name": @"Record Indirect Attribution", @"explanation": @"IDFA attribution"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            [Countly.sharedInstance recordDirectAttributionWithCampaignType:@"countly" andCampaignData:@"{\"cid\":\"CAMPAIGN_ID\",\"cuid\":\"CAMPAIGN_USER_ID\"}"];
        } break;

        case 1:
        {
            [Countly.sharedInstance recordIndirectAttribution:@{CLYAttributionKeyIDFA: @"SOME_IDFA_VALUE"}];
        } break;

        default: break;
    }
}

@end
