// TestPushPopViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "TestPushPopViewController.h"

@implementation TestPushPopViewController

- (IBAction)onClick_pushNew:(id)sender
{
    UINavigationController* nc = (UINavigationController*)self.parentViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
    TestPushPopViewController* tppvc = [storyboard instantiateViewControllerWithIdentifier:@"TestPushPopViewController"];
    tppvc.title = [NSString stringWithFormat:@"%@%d", NSStringFromClass(self.class), (int)nc.viewControllers.count];
    [nc pushViewController:tppvc animated:YES];
}


- (IBAction)onClick_dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
