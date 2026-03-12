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

            Countly.user.name = @"John Doe";
            Countly.user.email = @"john@doe.com";
            Countly.user.birthYear = @(1970);
            Countly.user.organization = @"United Nations";
            Countly.user.gender = @"M";
            Countly.user.phone = @"+0123456789";
            Countly.user.pictureLocalPath = localImagePath;
            Countly.user.custom = @{@"testkey1": @"testvalue1", @"testkey2": @"testvalue2"};
            [Countly.user save];
        } break;

        case 3:
        {
            Countly.user.email = NSNull.null;
            Countly.user.birthYear = NSNull.null;
            Countly.user.gender = NSNull.null;
            [Countly.user save];
        } break;

        case 4:
        {
            [Countly.user set:@"key101" value:@"value101"];
            [Countly.user incrementBy:@"key102" value:@5];
            [Countly.user push:@"key103" value:@"singlevalue"];
            [Countly.user push:@"key104" values:@[@"first", @"second", @"third"]];
            [Countly.user push:@"key105" values:@[@"a", @"b", @"c", @"d"]];
            [Countly.user save];
        } break;

        case 5:
        {
            [Countly.user multiply:@"key102" value:@2];
            [Countly.user unSet:@"key103"];
            [Countly.user pull:@"key104" value:@"second"];
            [Countly.user pull:@"key105" values:@[@"a", @"d"]];
            [Countly.user save];
        } break;

        default: break;
    }
}

@end
