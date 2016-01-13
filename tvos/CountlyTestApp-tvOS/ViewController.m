// ViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "ViewController.h"
#import "Countly.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark -
- (IBAction)onClick_event:(id)sender
{
    NSLog(@"%s tag: %li",__FUNCTION__,(long)[sender tag]);
    
    switch ([sender tag])
    {
        case 1:
        [Countly.sharedInstance recordEvent:@"button-click"];
        break;
        
        case 2:
        [Countly.sharedInstance recordEvent:@"button-click" count:5];
        break;
        
        case 3:
        [Countly.sharedInstance recordEvent:@"button-click" sum:1.99];
        break;
        
        case 4:
        [Countly.sharedInstance recordEvent:@"button-click" count:5 sum:1.99];
        break;
        
        case 5:
        [Countly.sharedInstance recordEvent:@"button-click" segmentation:@{@"k" : @"v"}];
        break;
        
        case 6:
        [Countly.sharedInstance recordEvent:@"button-click" segmentation:@{@"k" : @"v"} count:5];
        break;
        
        case 7:
        [Countly.sharedInstance recordEvent:@"button-click" segmentation:@{@"k" : @"v"} count:5 sum:1.99];
        break;
        
        case 8:
        [Countly.sharedInstance recordEvent:@"button-click" segmentation:@{@"k" : @"v"} count:5 sum:1.99 duration:0.314];
        break;
        
        case 9:
        [Countly.sharedInstance startEvent:@"timed-event"];
        break;
        
        case 10:
        [Countly.sharedInstance endEvent:@"timed-event" segmentation:@{@"k" : @"v"} count:5 sum:1.99];
        break;
        
        default:break;
    }
}

@end