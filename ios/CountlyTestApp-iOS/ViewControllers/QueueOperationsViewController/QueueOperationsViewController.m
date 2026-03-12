// QueueOperationsViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "QueueOperationsViewController.h"
#import "Countly.h"

@implementation QueueOperationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Queue Operations";

    self.tests = @[
        @{@"name": @"Flush Queues", @"explanation": @"Clear request and event queues"},
        @{@"name": @"Replace All App Keys", @"explanation": @"Replace queued requests with current app key"},
        @{@"name": @"Remove Different App Keys", @"explanation": @"Remove requests with different app key"},
        @{@"name": @"Add Direct Request", @"explanation": @"custom_key=custom_value"},
        @{@"name": @"Add Custom Network Headers", @"explanation": @"X-Custom-Header: value"},
        @{@"name": @"Attempt to Send Stored Requests", @"explanation": @"Process pending requests"},
        @{@"name": @"Record Metrics", @"explanation": @"Record device metrics with override"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: [Countly.sharedInstance flushQueues]; break;
        case 1: [Countly.sharedInstance replaceAllAppKeysInQueueWithCurrentAppKey]; break;
        case 2: [Countly.sharedInstance removeDifferentAppKeysFromQueue]; break;
        case 3: [Countly.sharedInstance addDirectRequest:@{@"custom_key": @"custom_value"}]; break;
        case 4: [Countly.sharedInstance addCustomNetworkRequestHeaders:@{@"X-Custom-Header": @"value"}]; break;
        case 5: [Countly.sharedInstance attemptToSendStoredRequests]; break;
        case 6: [Countly.sharedInstance recordMetrics:@{CLYMetricKeyDevice: @"CustomDevice"}]; break;
        default: break;
    }
}

@end
