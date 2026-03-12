// MultithreadingViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "MultithreadingViewController.h"
#import "Countly.h"

@implementation MultithreadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Multithreading";

    self.tests = @[
        @{@"name": @"Own Queue Multithread Testing 1", @"explanation": @"MultithreadingEvent1 on 15 threads"},
        @{@"name": @"Own Queue Multithread Testing 2", @"explanation": @"MultithreadingEvent2 on 15 threads"},
        @{@"name": @"Own Queue Multithread Testing 3", @"explanation": @"MultithreadingEvent3 on 15 threads"},
        @{@"name": @"Global Queue Multithread Testing 1", @"explanation": @"MultithreadingEvent4"},
        @{@"name": @"Global Queue Multithread Testing 2", @"explanation": @"MultithreadingEvent5"},
        @{@"name": @"Global Queue Multithread Testing 3", @"explanation": @"MultithreadingEvent6"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    NSString *eventName = [@"MultithreadingEvent" stringByAppendingFormat:@"%d", (int)index + 1];

    for (int i = 0; i < 15; i++)
    {
        dispatch_queue_t queue;
        if (index >= 3)
        {
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }
        else
        {
            NSString *queueName = [@"ly.count.multithreading" stringByAppendingFormat:@"%d", i];
            queue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_CONCURRENT);
        }

        NSDictionary *segmentation = @{@"k": [@"v" stringByAppendingFormat:@"%d", i]};

        dispatch_async(queue, ^{
            [Countly.sharedInstance recordEvent:eventName segmentation:segmentation];
            NSLog(@"Thread %d", i);
        });
    }
}

@end
