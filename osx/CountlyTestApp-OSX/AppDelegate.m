// AppDelegate.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "AppDelegate.h"
#import "Countly.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//start Countly
//  [Countly.sharedInstance start:@"YOUR_APP_KEY" withHost:@"https://YOUR_API_HOST.com"];
//
//or use convenience method for Countly Cloud
//
//  [Countly.sharedInstance startOnCloudWithAppKey:@"YOUR_APP_KEY"];
    
    self.window.backgroundColor = [NSColor colorWithCalibratedRed:65/255.0 green:178/255.0 blue:70/255.0 alpha:1];

//uncomment these lines (and some in main.m) for displaying console logs inside the test app
//    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.0];
}


- (IBAction)onClick_events:(id)sender
{
    switch ([sender tag])
    {
        case 1:
        {
            [Countly.sharedInstance recordEvent:@"EventA" count:1];
            NSLog(@"\nRecorded event 'EventA' with count: 1");
        }break;
            
        case 2:
        {
            [Countly.sharedInstance recordEvent:@"EventA" count:3 sum:4.99];
            NSLog(@"\nRecorded event 'EventA' with count: 1 and sum: 4.99");
        }break;
            
        case 3:
        {
            [Countly.sharedInstance recordEvent:@"EventB" segmentation:@{@"aSegKey" : @"aValue"} count:5];
            NSLog(@"\nRecorded event 'EventB' with segmentation 'aSegKey':'aValue' and count: 5");
        }break;
            
        case 4:
        {
            [Countly.sharedInstance recordEvent:@"EventB" segmentation:@{@"aSegKey" : @"aValue"} count:7 sum:3.94];
            NSLog(@"\nRecorded event 'EventB' with segmentation 'aSegKey':'aValue' and count: 7 and sum: 3.49");
        }break;
            
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
