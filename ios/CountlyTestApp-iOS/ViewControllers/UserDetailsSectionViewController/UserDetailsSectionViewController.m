// UserDetailsSectionViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "UserDetailsSectionViewController.h"
#import "UserDetailsEditorViewController.h"
#import "UserDetailsCustomModifiersViewController.h"
#import "Countly.h"

@implementation UserDetailsSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"User Details";

    self.tests = @[
        @{@"name": @"Record User Details", @"explanation": @""},
        @{@"name": @"Custom Property Modifiers", @"explanation": @""},
        @{@"name": @"Dummy User Details", @"explanation": @"Dummy John Doe data"},
        @{@"name": @"Delete Some User Details by Nulling", @"explanation": @"email, birthYear, gender"},
        @{@"name": @"Some Custom Property Modifiers 1", @"explanation": @"set-incrementBy-push-save"},
        @{@"name": @"Some Custom Property Modifiers 2", @"explanation": @"multiply-unset-pull-save"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
            UserDetailsEditorViewController *udvc = [storyboard instantiateViewControllerWithIdentifier:@"UserDetailsEditorViewController"];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:udvc];
            [self presentViewController:nc animated:YES completion:nil];
        } break;

        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
            UserDetailsCustomModifiersViewController *udvc = [storyboard instantiateViewControllerWithIdentifier:@"UserDetailsCustomModifiersViewController"];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:udvc];
            [self presentViewController:nc animated:YES completion:nil];
        } break;

        case 2:
        {
            NSURL *documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
            NSString *localImagePath = [documentsDirectory.absoluteString stringByAppendingPathComponent:@"SamplePicture.jpg"];

            Countly.sharedInstance.userProfile.name = @"John Doe";
            Countly.sharedInstance.userProfile.email = @"john@doe.com";
            Countly.sharedInstance.userProfile.birthYear = @(1970);
            Countly.sharedInstance.userProfile.organization = @"United Nations";
            Countly.sharedInstance.userProfile.gender = @"M";
            Countly.sharedInstance.userProfile.phone = @"+0123456789";
            Countly.sharedInstance.userProfile.pictureLocalPath = localImagePath;
            Countly.sharedInstance.userProfile.custom = @{@"testkey1": @"testvalue1", @"testkey2": @"testvalue2"};
            [Countly.sharedInstance.userProfile save];
        } break;

        case 3:
        {
            Countly.sharedInstance.userProfile.email = NSNull.null;
            Countly.sharedInstance.userProfile.birthYear = NSNull.null;
            Countly.sharedInstance.userProfile.gender = NSNull.null;
            [Countly.sharedInstance.userProfile save];
        } break;

        case 4:
        {
            [Countly.sharedInstance.userProfile set:@"key101" value:@"value101"];
            [Countly.sharedInstance.userProfile incrementBy:@"key102" value:@5];
            [Countly.sharedInstance.userProfile push:@"key103" value:@"singlevalue"];
            [Countly.sharedInstance.userProfile push:@"key104" values:@[@"first", @"second", @"third"]];
            [Countly.sharedInstance.userProfile push:@"key105" values:@[@"a", @"b", @"c", @"d"]];
            [Countly.sharedInstance.userProfile save];
        } break;

        case 5:
        {
            [Countly.sharedInstance.userProfile multiply:@"key102" value:@2];
            [Countly.sharedInstance.userProfile unSet:@"key103"];
            [Countly.sharedInstance.userProfile pull:@"key104" value:@"second"];
            [Countly.sharedInstance.userProfile pull:@"key105" values:@[@"a", @"d"]];
            [Countly.sharedInstance.userProfile save];
        } break;

        default: break;
    }
}

@end
