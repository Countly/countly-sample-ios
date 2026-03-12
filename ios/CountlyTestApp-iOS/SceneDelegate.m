// SceneDelegate.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "SceneDelegate.h"
#import "MainViewController.h"
#import "TestModalViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
    MainViewController *mvc = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mvc];

    // Modern navigation bar with large titles
    nc.navigationBar.prefersLargeTitles = YES;
    nc.navigationBar.tintColor = [UIColor systemGreenColor];

    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];

    // Handle URL contexts passed at launch
    for (UIOpenURLContext *urlContext in connectionOptions.URLContexts)
    {
        [self handleDeepLinkURL:urlContext.URL];
    }
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    for (UIOpenURLContext *urlContext in URLContexts)
    {
        [self handleDeepLinkURL:urlContext.URL];
    }
}

- (void)handleDeepLinkURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:@"countly"])
    {
        NSString *product = url.host;

        if ([product isEqualToString:@"productA"] || [product isEqualToString:@"productB"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
            TestModalViewController *tmvc = [storyboard instantiateViewControllerWithIdentifier:@"TestModalViewController"];
            tmvc.title = [@"Page of " stringByAppendingString:product];
            [self.window.rootViewController presentViewController:tmvc animated:YES completion:nil];
        }
    }
}

@end
