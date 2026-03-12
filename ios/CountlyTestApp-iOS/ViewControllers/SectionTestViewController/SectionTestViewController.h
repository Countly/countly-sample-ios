// SectionTestViewController.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import <UIKit/UIKit.h>

@interface SectionTestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray *tests;
@property (nonatomic) UITableView *tableView;
- (void)handleTestAtIndex:(NSInteger)index;
@end
