//
// ViewController.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate>
- (IBAction)onClick_event:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *txt_log;
@property (strong, nonatomic) IBOutlet UIPageControl *pgc_main;
@property (strong, nonatomic) IBOutlet UIScrollView *scr_main;

@end
