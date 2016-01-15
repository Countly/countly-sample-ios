// InterfaceController.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tbl_events;

@end
