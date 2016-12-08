// TestViewControllerPushPop.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "TestViewControllerPushPop.h"

@implementation TestViewControllerPushPop

- (IBAction)onClick_pushNew:(id)sender
{
    UINavigationController* nc = (UINavigationController*)self.parentViewController;
    TestViewControllerPushPop* testViewControllerPushPop = [TestViewControllerPushPop.alloc initWithNibName:@"TestViewControllerPushPop" bundle:nil];
    testViewControllerPushPop.title = [NSString stringWithFormat:@"%@%d", NSStringFromClass(self.class), (int)nc.viewControllers.count];
    [nc pushViewController:testViewControllerPushPop animated:YES];
}

- (IBAction)onClick_dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
