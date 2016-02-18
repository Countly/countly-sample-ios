// AppDelegate.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "AppDelegate.h"
#import "Countly.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CountlyConfig* config = CountlyConfig.new;
    config.appKey = @"YOUR_APP_KEY";
    config.host = @"https://YOUR_COUNTLY_SERVER";
//  config.deviceID = @"customDeviceID"                               //Optional custom or system generated device ID
//  config.features = @[CLYAPM];                                      //Optional features
    [Countly.sharedInstance startWithConfig:config];
    
    self.window.backgroundColor = [NSColor colorWithCalibratedRed:65/255.0 green:178/255.0 blue:70/255.0 alpha:1];

//uncomment these lines (and some in main.m) for displaying console logs inside the test app
//    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.0];
}


- (IBAction)onClick_events:(id)sender
{
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
            [Countly.sharedInstance recordEvent:@"button-click" duration:3.14];
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
            [Countly.sharedInstance endEvent:@"timed-event" segmentation:@{@"k" : @"v"} count:1 sum:0];
        break;
        
        default:break;
    }
}


-(void)updateLogs
{
    NSString *logFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"logfile.log"];
    
    NSData *d = [NSData dataWithContentsOfFile:logFilePath];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    if(![s isEqualToString:@""] && ![s isEqualToString:self.txt_log.string])
    {
        [self.txt_log setString:s];

        NSRange myRange=NSMakeRange(self.txt_log.string.length, 0);
        [self.txt_log scrollRangeToVisible:myRange];
    }
    
    s = nil;
    
    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.2];
}
@end
