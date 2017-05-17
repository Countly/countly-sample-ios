// TestModalViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "TestModalViewController.h"

@interface TestModalViewController ()
@end

@implementation TestModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)onClick_dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
