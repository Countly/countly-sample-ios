// AppDelegate.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextView *txt_log;

- (IBAction)onClick_events:(id)sender;

@end
