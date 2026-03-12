// ViewTrackingViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "ViewTrackingViewController.h"
#import "TestModalViewController.h"
#import "TestPushPopViewController.h"
#import "Countly.h"

@interface ViewTrackingViewController ()
@property (nonatomic) NSString *lastViewID;
@end

@implementation ViewTrackingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"View Tracking";

    self.tests = @[
        @{@"name": @"Deactivate AutoViewTracking", @"explanation": @""},
        @{@"name": @"Activate AutoViewTracking", @"explanation": @""},
        @{@"name": @"Present Modal View Controller", @"explanation": @""},
        @{@"name": @"Push / Pop with Navigation Controller", @"explanation": @""},
        @{@"name": @"Add Exception with Class Name", @"explanation": @"TestModalViewController.class"},
        @{@"name": @"Remove Exception with Class Name", @"explanation": @"TestModalViewController.class"},
        @{@"name": @"Add Exception with Title", @"explanation": @"MyViewControllerTitle"},
        @{@"name": @"Remove Exception with Title", @"explanation": @"MyViewControllerTitle"},
        @{@"name": @"Add Exception with Custom titleView", @"explanation": @"MyViewControllerCustomTitleView"},
        @{@"name": @"Remove Exception with Custom titleView", @"explanation": @"MyViewControllerCustomTitleView"},
        @{@"name": @"Report View Manually (deprecated)", @"explanation": @"ManualViewReportExample_MyMainView"},
        @{@"name": @"Start View", @"explanation": @"TestView"},
        @{@"name": @"Start View with Segmentation", @"explanation": @"TestView sg:{screen:main}"},
        @{@"name": @"Start Auto-Stopped View", @"explanation": @"AutoStoppedTestView"},
        @{@"name": @"Start Auto-Stopped View with Segmentation", @"explanation": @"AutoStoppedTestView sg:{screen:detail}"},
        @{@"name": @"Stop View with Name", @"explanation": @"TestView"},
        @{@"name": @"Stop View with Name & Segmentation", @"explanation": @"TestView sg:{action:close}"},
        @{@"name": @"Stop View with ID", @"explanation": @"Uses last started view ID"},
        @{@"name": @"Stop View with ID & Segmentation", @"explanation": @"Uses last started view ID"},
        @{@"name": @"Pause View with ID", @"explanation": @"Uses last started view ID"},
        @{@"name": @"Resume View with ID", @"explanation": @"Uses last started view ID"},
        @{@"name": @"Stop All Views", @"explanation": @"With segmentation"},
        @{@"name": @"Set Global View Segmentation", @"explanation": @"{platform:iOS}"},
        @{@"name": @"Update Global View Segmentation", @"explanation": @"{version:2.0}"},
        @{@"name": @"Add Segmentation to View with ID", @"explanation": @"Uses last started view ID"},
        @{@"name": @"Add Segmentation to View with Name", @"explanation": @"TestView"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case 0: Countly.sharedInstance.isAutoViewTrackingActive = NO; break;
        case 1: Countly.sharedInstance.isAutoViewTrackingActive = YES; break;
#pragma clang diagnostic pop

        case 2:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
            TestModalViewController *tmvc = [storyboard instantiateViewControllerWithIdentifier:@"TestModalViewController"];
            tmvc.title = @"MyViewControllerTitle";
            [self presentViewController:tmvc animated:YES completion:nil];
        } break;

        case 3:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
            TestPushPopViewController *tppvc = [storyboard instantiateViewControllerWithIdentifier:@"TestPushPopViewController"];

            UILabel *titleView = [[UILabel alloc] initWithFrame:(CGRect){0, 0, 320, 30}];
            titleView.text = @"MyViewControllerCustomTitleView";
            titleView.textAlignment = NSTextAlignmentCenter;
            titleView.textColor = UIColor.redColor;
            titleView.font = [UIFont systemFontOfSize:12];
            tppvc.navigationItem.titleView = titleView;
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tppvc];
            nc.title = @"TestPushPopViewController";
            [self presentViewController:nc animated:YES completion:nil];
        } break;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case 4: [Countly.sharedInstance addExceptionForAutoViewTracking:NSStringFromClass(TestModalViewController.class)]; break;
        case 5: [Countly.sharedInstance removeExceptionForAutoViewTracking:NSStringFromClass(TestModalViewController.class)]; break;
        case 6: [Countly.sharedInstance addExceptionForAutoViewTracking:@"MyViewControllerTitle"]; break;
        case 7: [Countly.sharedInstance removeExceptionForAutoViewTracking:@"MyViewControllerTitle"]; break;
        case 8: [Countly.sharedInstance addExceptionForAutoViewTracking:@"MyViewControllerCustomTitleView"]; break;
        case 9: [Countly.sharedInstance removeExceptionForAutoViewTracking:@"MyViewControllerCustomTitleView"]; break;
        case 10: [Countly.sharedInstance recordView:@"ManualViewReportExample_MyMainView"]; break;
#pragma clang diagnostic pop

        case 11: self.lastViewID = [Countly.sharedInstance.views startView:@"TestView"]; break;
        case 12: self.lastViewID = [Countly.sharedInstance.views startView:@"TestView" segmentation:@{@"screen": @"main"}]; break;
        case 13: self.lastViewID = [Countly.sharedInstance.views startAutoStoppedView:@"AutoStoppedTestView"]; break;
        case 14: self.lastViewID = [Countly.sharedInstance.views startAutoStoppedView:@"AutoStoppedTestView" segmentation:@{@"screen": @"detail"}]; break;
        case 15: [Countly.sharedInstance.views stopViewWithName:@"TestView"]; break;
        case 16: [Countly.sharedInstance.views stopViewWithName:@"TestView" segmentation:@{@"action": @"close"}]; break;

        case 17:
            if (self.lastViewID) [Countly.sharedInstance.views stopViewWithID:self.lastViewID];
            break;

        case 18:
            if (self.lastViewID) [Countly.sharedInstance.views stopViewWithID:self.lastViewID segmentation:@{@"action": @"close"}];
            break;

        case 19:
            if (self.lastViewID) [Countly.sharedInstance.views pauseViewWithID:self.lastViewID];
            break;

        case 20:
            if (self.lastViewID) [Countly.sharedInstance.views resumeViewWithID:self.lastViewID];
            break;

        case 21: [Countly.sharedInstance.views stopAllViews:@{@"reason": @"manual_stop"}]; break;
        case 22: [Countly.sharedInstance.views setGlobalViewSegmentation:@{@"platform": @"iOS"}]; break;
        case 23: [Countly.sharedInstance.views updateGlobalViewSegmentation:@{@"version": @"2.0"}]; break;

        case 24:
            if (self.lastViewID) [Countly.sharedInstance.views addSegmentationToViewWithID:self.lastViewID segmentation:@{@"extra": @"data"}];
            break;

        case 25: [Countly.sharedInstance.views addSegmentationToViewWithName:@"TestView" segmentation:@{@"extra": @"data"}]; break;

        default: break;
    }
}

@end
