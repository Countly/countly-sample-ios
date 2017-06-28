// TestModalViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "TestModalViewController.h"

@interface TestModalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation TestModalViewController

- (void)viewWillAppear:(BOOL)animated
{
    if(self.title.length)
        self.titleLabel.text = self.title;

    [super viewWillAppear:animated];
}


- (IBAction)onClick_dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
