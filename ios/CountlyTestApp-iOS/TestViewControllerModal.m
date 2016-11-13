// TestViewControllerModal.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "TestViewControllerModal.h"

@interface TestViewControllerModal ()
@end

@implementation TestViewControllerModal

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)onClick_dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
