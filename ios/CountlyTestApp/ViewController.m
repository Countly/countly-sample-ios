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
    
    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.0];
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
    NSLog(@"%s tag: %li",__FUNCTION__,(long)[sender tag]);

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

-(void)updateLogs
{
    NSString *logFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"logfile.log"];
    
    NSData *d = [NSData dataWithContentsOfFile:logFilePath];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    if(![s isEqualToString:@""])
        self.txt_log.text = s;
    
    NSRange myRange=NSMakeRange(self.txt_log.text.length, 0);
    [self.txt_log scrollRangeToVisible:myRange];

    s = nil;
    
    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.2];
}
@end
