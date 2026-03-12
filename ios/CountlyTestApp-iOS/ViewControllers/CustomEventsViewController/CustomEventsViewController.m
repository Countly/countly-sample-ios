// CustomEventsViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "CustomEventsViewController.h"
#import "EventCreatorViewController.h"
#import "Countly.h"

@implementation CustomEventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Custom Events";

    self.tests = @[
        @{@"name": @"Create a Custom Event", @"explanation": @""},
        @{@"name": @"Record Event", @"explanation": @"TestEventA"},
        @{@"name": @"Record Event with Count", @"explanation": @"TestEventA  c:5"},
        @{@"name": @"Record Event with Sum", @"explanation": @"TestEventB  s:1.99"},
        @{@"name": @"Record Event with Duration", @"explanation": @"TestEventB  d:3.14"},
        @{@"name": @"Record Event with Count & Sum", @"explanation": @"TestEventB  c:5 s:1.99"},
        @{@"name": @"Record Event with Segmentation", @"explanation": @"TestEventC  sg:{k:v}"},
        @{@"name": @"Record Event with Segmentation & Count", @"explanation": @"TestEventC  sg:{k:v}  c:5"},
        @{@"name": @"Record Event with Segmentation, Count & Sum", @"explanation": @"TestEventD  sg:{k:v}  c:5  s:1.99"},
        @{@"name": @"Record Event with Segmentation, Count, Sum & Dur.", @"explanation": @"TestEventD  sg:{k:v}  c:5  s:1.99  d:0.314"},
        @{@"name": @"Start Event", @"explanation": @"timed-event"},
        @{@"name": @"End Event", @"explanation": @"timed-event"},
        @{@"name": @"End Event with Segmentation, Count & Sum", @"explanation": @"timed-event  sg:{k:v}  c:1  s:0"},
        @{@"name": @"Cancel Event", @"explanation": @"timed-event"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
            EventCreatorViewController *ecvc = [storyboard instantiateViewControllerWithIdentifier:@"EventCreatorViewController"];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:ecvc];
            [self presentViewController:nc animated:YES completion:nil];
        } break;

        case 1: [Countly.sharedInstance recordEvent:@"TestEventA"]; break;
        case 2: [Countly.sharedInstance recordEvent:@"TestEventA" count:5]; break;
        case 3: [Countly.sharedInstance recordEvent:@"TestEventB" sum:1.99]; break;
        case 4: [Countly.sharedInstance recordEvent:@"TestEventB" duration:3.14]; break;
        case 5: [Countly.sharedInstance recordEvent:@"TestEventB" count:5 sum:1.99]; break;
        case 6: [Countly.sharedInstance recordEvent:@"TestEventC" segmentation:@{@"k": @"v"}]; break;
        case 7: [Countly.sharedInstance recordEvent:@"TestEventC" segmentation:@{@"k": @"v"} count:5]; break;
        case 8: [Countly.sharedInstance recordEvent:@"TestEventD" segmentation:@{@"k": @"v"} count:5 sum:1.99]; break;
        case 9: [Countly.sharedInstance recordEvent:@"TestEventD" segmentation:@{@"k": @"v"} count:5 sum:1.99 duration:0.314]; break;
        case 10: [Countly.sharedInstance startEvent:@"timed-event"]; break;
        case 11: [Countly.sharedInstance endEvent:@"timed-event"]; break;
        case 12: [Countly.sharedInstance endEvent:@"timed-event" segmentation:@{@"k": @"v"} count:1 sum:0]; break;
        case 13: [Countly.sharedInstance cancelEvent:@"timed-event"]; break;
        default: break;
    }
}

@end
