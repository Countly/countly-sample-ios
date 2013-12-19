//
// ViewController.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "ViewController.h"
#import "Countly.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (IBAction)onClick_event:(id)sender
{
    NSLog(@"%s tag: %i",__FUNCTION__,[sender tag]);

    switch ([sender tag])
    {
        case 1: [[Countly sharedInstance] recordEvent:@"button-click" count:1];
            break;

        case 2: [[Countly sharedInstance] recordEvent:@"button-click" count:1 sum:1.99];
            break;

        case 3: [[Countly sharedInstance] recordEvent:@"button-click" segmentation:@{@"seg_test" : @"seg_value"} count:1];
            break;

        case 4: [[Countly sharedInstance] recordEvent:@"button-click" segmentation:@{@"seg_test" : @"seg_value"} count:1 sum:1.99];
            break;
            
        default:
            break;
    }
}
@end
