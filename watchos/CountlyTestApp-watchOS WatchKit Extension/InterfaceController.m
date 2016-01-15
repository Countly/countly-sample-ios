// InterfaceController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "InterfaceController.h"
#import "RowController.h"
#import "Countly.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    NSArray* testButtonTitles = @[
                                    @"record event",
                                    @"record event with count",
                                    @"record event with sum",
                                    @"record event with duration",
                                    @"record event with segm.",
                                    @"record event with segm.\n & count",
                                    @"record event with segm.\n count & sum",
                                    @"record event with segm.\n count, sum & duration",
                                    @"start event",
                                    @"end event"
                                 ];
    
    [self.tbl_events setNumberOfRows:testButtonTitles.count withRowType:@"RowControllerID"];
    for (NSInteger i = 0; i < self.tbl_events.numberOfRows; i++)
    {
        RowController* row = [self.tbl_events rowControllerAtIndex:i];
        row.label.text = testButtonTitles[i];
    }
    
    [super awakeWithContext:context];
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    int pressedButton = rowIndex + 1;
    
    NSLog(@"%s pressed: %i", __FUNCTION__, pressedButton);
    
    switch (rowIndex+1)
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

@end