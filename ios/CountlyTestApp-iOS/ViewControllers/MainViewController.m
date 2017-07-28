// MainViewController.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "MainViewController.h"
#import "Countly.h"
#import "TestModalViewController.h"
#import "TestPushPopViewController.h"
#import "EventCreatorViewController.h"
#import "UserDetailsEditorViewController.h"
#import "UserDetailsCustomModifiersViewController.h"
#import "EYLogViewer.h"

@interface MainViewController ()
{
    NSArray* sections;
    NSArray* tests;
    NSArray* explanations;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_main;
@end

typedef enum : NSUInteger
{
    TestSectionCustomEvents,
    TestSectionCrashReporting,
    TestSectionUserDetails,
    TestSectionAPM,
    TestSectionViewTracking,
    TestSectionPushNotifications,
    TestSectionMultithreading,
    TestSectionOthers
} TestSection;

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //copy pictures from App Bundle to Documents directory, to use later for User Details picture upload tests.
    NSURL* documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;

    NSArray *fileTypes = @[@"gif",@"jpg",@"png"];
    [fileTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        NSURL* bundleFileURL = [NSBundle.mainBundle URLForResource:@"SamplePicture" withExtension:((NSString*)obj).lowercaseString];
        NSURL* destinationURL = [documentsDirectory URLByAppendingPathComponent:bundleFileURL.lastPathComponent];
        [NSFileManager.defaultManager copyItemAtURL:bundleFileURL toURL:destinationURL error:nil];
    }];

    sections =
    @[
        @"Custom Events",
        @"Crash Reporting",
        @"User Details",
        @"APM",
        @"View Tracking",
        @"Push Notifications",
        @"Multithreading",
        @"Others"
    ];

    tests =
    @[
        @[
            @"Create a Custom Event",
            @"Record Event",
            @"Record Event with Count",
            @"Record Event with Sum",
            @"Record Event with Duration",
            @"Record Event with Count & Sum",
            @"Record Event with Segmentation",
            @"Record Event with Segmentation & Count",
            @"Record Event with Segmentation, Count & Sum",
            @"Record Event with Segmentation, Count, Sum & Dur.",
            @"Start Event",
            @"End Event",
            @"End Event with Segmentation, Count & Sum",
        ],

        @[
            @"Unrecognized Selector",
            @"Out of Bounds",
            @"NULL pointer",
            @"Invalid Geometry",
            @"Assert Fail",
            @"Terminate",
            @"Terminate 2",
            @"Custom Crash Log",
            @"Record Handled Exception",
            @"Record Handled Exception with Stack Trace"
        ],

        @[
            @"Record User Details",
            @"Custom Property Modifiers",
            @"Dummy User Details",
            @"Delete Some User Details by Nulling",
            @"Some Custom Property Modifiers 1",
            @"Some Custom Property Modifiers 2",
            @"User Logged in",
            @"User Logged out"
        ],

        @[
            @"sendSynchronous",
            @"sendAsynchronous",
            @"connectionWithRequest",
            @"initWithRequest",
            @"initWithRequest:startImmediately NO",
            @"initWithRequest:startImmediately YES",
            @"dataTaskWithRequest",
            @"dataTaskWithRequest:completionHandler",
            @"dataTaskWithURL",
            @"dataTaskWithURL:completionHandler",
            @"downloadTaskWithRequest",
            @"downloadTaskWithRequest:completionHandler",
            @"downloadTaskWithURL",
            @"downloadTaskWithURL:completionHandler",
            @"Add Exception URL",
            @"Remove Exception URL"
        ],

        @[
            @"Turn off AutoViewTracking",
            @"Turn on AutoViewTracking",
            @"Present Modal View Controller",
            @"Push / Pop with Navigation Controller ",
            @"Add Exception with Class Name",
            @"Remove Exception with Class Name",
            @"Add Exception with Title",
            @"Remove Exception with Title",
            @"Add Exception with Custom titleView",
            @"Remove Exception with Custom titleView",
            @"Report View Manually"
        ],

        @[
            @"Ask for Notification Permission",
            @"Ask for Notification Permission with Completion Handler",
            @"Record Geo-Location for Push",
            @"Record Push Notification Action"
        ],

        @[
            @"Own Queue Multithread Testing 1",
            @"Own Queue Multithread Testing 2",
            @"Own Queue Multithread Testing 3",
            @"Global Queue Multithread Testing 1",
            @"Global Queue Multithread Testing 2",
            @"Global Queue Multithread Testing 3",
        ],

        @[
            @"Set Custom Header Field Value",
            @"Ask for Star-Rating",
            @"Set New Device ID",
            @"Set New Device ID with Server Merge",
            @"Begin Session",
            @"Update Session",
            @"End Session"
        ]
    ];

    explanations =
    @[
        @[
            @"",
            @"TestEventA",
            @"TestEventA  c:5",
            @"TestEventB  s:1.99",
            @"TestEventB  d:3.14",
            @"TestEventB  c:5 s:1.99",
            @"TestEventC  sg:{k:v}",
            @"TestEventC  sg:{k:v}  c:5",
            @"TestEventD  sg:{k:v}  c:5  s:1.99",
            @"TestEventD  sg:{k:v}  c:5  s:1.99  d:0.314",
            @"timed-event",
            @"timed-event",
            @"timed-event  sg:{k:v}  c:1  s:0",
        ],
        @[
            @"thisIsTheUnrecognizedSelectorCausingTheCrash",
            @"5th element in a 3 elements array",
            @"dereference",
            @"CALayer position contains nan",
            @"This is the test assert that failed!",
            @"kill SIGABRT",
            @"__builtin_trap SIGTERM",
            @"This is a custom crash log!",
            @"n:MyException  r:MyReason  d:{key:value}",
            @"n:MyExc  r:MyReason  d:{key:value} and stack trace"
        ],

        @[
            @"",
            @"",
            @"Dummy John Doe data",
            @"email, birthYear, gender",
            @"set-incrementBy-push-save",
            @"multiply-unset-pull-save",
            @"OwnUserID",
            @"switch back to IDFV and start new session"
        ],

        @[
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"",
            @"http://finance.yahoo.com",
            @"http://finance.yahoo.com"
        ],

        @[
            @"",
            @"",
            @"",
            @"",
            @"TestModalViewController.class",
            @"TestModalViewController.class",
            @"MyViewControllerTitle",
            @"MyViewControllerTitle",
            @"MyViewControllerCustomTitleView",
            @"MyViewControllerCustomTitleView",
            @"ManualViewReportExample_MyMainView"
        ],

        @[
            @"",
            @"",
            @"33.6789, 43.1234",
            @"for manually handled push notifications"
        ],

        @[
            @"MultithreadingEvent1 on 15 threads",
            @"MultithreadingEvent3 on 15 threads",
            @"MultithreadingEvent3 on 15 threads",
            @"MultithreadingEvent4",
            @"MultithreadingEvent5",
            @"MultithreadingEvent6"
        ],

        @[
            @"thisismyvalue",
            @"",
            @"user@example.com",
            @"IDFV",
            @"manual session handling",
            @"manual session handling",
            @"manual session handling"
        ]
    ];

    [self.tbl_main reloadData];
    
    NSInteger startSection = TestSectionCustomEvents; //start section of testing app can be set here.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [self.tbl_main scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:startSection] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark -

- (IBAction)onClick_console:(id)sender
{
//    static bool isHidden = NO;
//    
//    isHidden = !isHidden;
//
//    if(isHidden)
//        [EYLogViewer hide];
//    else
//        [EYLogViewer show];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tests[section] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = UIView.new;
    headerView.backgroundColor = UIColor.grayColor;
    UIImageView* imageView = [UIImageView.alloc initWithFrame:(CGRect){15,6,12,12}];
    imageView.image = [UIImage imageNamed:[sections[section] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [headerView addSubview:imageView];
    UILabel* label = [UILabel.alloc initWithFrame:(CGRect){33,0,320,24}];
    label.font = [UIFont fontWithName:@"AvenirNext-bold" size:14];
    label.textColor = UIColor.whiteColor;
    label.text = sections[section];
    [headerView addSubview:label];

    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kCountlyCellIdentifier = @"kCountlyCellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCountlyCellIdentifier];
    
    if(!cell)
    {
        cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCountlyCellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-medium" size:14];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Menlo" size:11];
    }

    cell.textLabel.text = tests[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = explanations[indexPath.section][indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Test: %@ - %@",sections[indexPath.section],tests[indexPath.section][indexPath.row]);

    switch (indexPath.section)
    {
#pragma mark Custom Events
        case TestSectionCustomEvents:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
                    EventCreatorViewController *ecvc = [storyboard instantiateViewControllerWithIdentifier:@"EventCreatorViewController"];
                    UINavigationController* nc = [UINavigationController.alloc initWithRootViewController:ecvc];
                    [self presentViewController:nc animated:YES completion:nil];
                }
                break;
            
                case 1: [Countly.sharedInstance recordEvent:@"TestEventA"];
                break;

                case 2: [Countly.sharedInstance recordEvent:@"TestEventA" count:5];
                break;

                case 3: [Countly.sharedInstance recordEvent:@"TestEventB" sum:1.99];
                break;

                case 4: [Countly.sharedInstance recordEvent:@"TestEventB" duration:3.14];
                break;

                case 5: [Countly.sharedInstance recordEvent:@"TestEventB" count:5 sum:1.99];
                break;

                case 6: [Countly.sharedInstance recordEvent:@"TestEventC" segmentation:@{@"k" : @"v"}];
                break;

                case 7: [Countly.sharedInstance recordEvent:@"TestEventC" segmentation:@{@"k" : @"v"} count:5];
                break;

                case 8: [Countly.sharedInstance recordEvent:@"TestEventD" segmentation:@{@"k" : @"v"} count:5 sum:1.99];
                break;

                case 9: [Countly.sharedInstance recordEvent:@"TestEventD" segmentation:@{@"k" : @"v"} count:5 sum:1.99 duration:0.314];
                break;

                case 10: [Countly.sharedInstance startEvent:@"timed-event"];
                break;

                case 11: [Countly.sharedInstance endEvent:@"timed-event"];
                break;

                case 12: [Countly.sharedInstance endEvent:@"timed-event" segmentation:@{@"k" : @"v"} count:1 sum:0];
                break;

                default:break;
            }
        }
        break;


#pragma mark Crash Reporting
        case TestSectionCrashReporting:
        {
            switch (indexPath.row)
            {
                case 0: [self crashTest0];
                break;

                case 1: [self crashTest1];
                break;

                case 2: [self crashTest2];
                break;

                case 3: [self crashTest3];
                break;

                case 4: [self crashTest4];
                break;
                
                case 5: [self crashTest5];
                break;

                case 6: [self crashTest6];
                break;

                case 7: [Countly.sharedInstance crashLog:@"This is a custom crash log!"];
                break;

                case 8:
                {
                    NSException* myException = [NSException exceptionWithName:@"MyException" reason:@"MyReason" userInfo:@{@"key":@"value"}];
                    [Countly.sharedInstance recordHandledException:myException];
                }break;

                case 9:
                {
                    NSException* myException = [NSException exceptionWithName:@"MyExc" reason:@"MyReason" userInfo:@{@"key":@"value"}];
                    [Countly.sharedInstance recordHandledException:myException withStackTrace:[NSThread callStackSymbols]];
                }break;

                default: break;
            }
        }
        break;


#pragma mark User Details
        case TestSectionUserDetails:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
                    UserDetailsEditorViewController *udvc = [storyboard instantiateViewControllerWithIdentifier:@"UserDetailsEditorViewController"];
                    UINavigationController* nc = [UINavigationController.alloc initWithRootViewController:udvc];
                    [self presentViewController:nc animated:YES completion:nil];
                }break;

                case 1:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
                    UserDetailsCustomModifiersViewController *udvc = [storyboard instantiateViewControllerWithIdentifier:@"UserDetailsCustomModifiersViewController"];
                    UINavigationController* nc = [UINavigationController.alloc initWithRootViewController:udvc];
                    [self presentViewController:nc animated:YES completion:nil];
                }break;

                case 2:
                {
                    NSURL* documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
                    NSString* localImagePath = [documentsDirectory.absoluteString stringByAppendingPathComponent:@"SamplePicture.jpg"];
                    // SamplePicture.png or SamplePicture.gif can be used too.

                    Countly.user.name = @"John Doe";
                    Countly.user.email = @"john@doe.com";
                    Countly.user.birthYear = @(1970);
                    Countly.user.organization = @"United Nations";
                    Countly.user.gender = @"M";
                    Countly.user.phone = @"+0123456789";
                    //Countly.user.pictureURL = @"http://s12.postimg.org/qji0724gd/988a10da33b57631caa7ee8e2b5a9036.jpg";
                    Countly.user.pictureLocalPath = localImagePath;
                    Countly.user.custom = @{@"testkey1":@"testvalue1",@"testkey2":@"testvalue2"};

                    [Countly.user save];
                }break;

                case 3:
                {
                    Countly.user.email = NSNull.null;
                    Countly.user.birthYear = NSNull.null;
                    Countly.user.gender = NSNull.null;

                    [Countly.user save];
                }break;

                case 4:
                {
                    [Countly.user set:@"key101" value:@"value101"];
                    [Countly.user incrementBy:@"key102" value:@5];
                    [Countly.user push:@"key103" value:@"singlevalue"];
                    [Countly.user push:@"key104" values:@[@"first",@"second",@"third"]];
                    [Countly.user push:@"key105" values:@[@"a",@"b",@"c",@"d"]];

                    [Countly.user save];
                }break;

                case 5:
                {
                    [Countly.user multiply:@"key102" value:@2];
                    [Countly.user unSet:@"key103"];
                    [Countly.user pull:@"key104" value:@"second"];
                    [Countly.user pull:@"key105" values:@[@"a",@"d"]];

                    [Countly.user save];
                }break;

                case 6: [Countly.sharedInstance userLoggedIn:@"OwnUserID"];
                break;

                case 7: [Countly.sharedInstance userLoggedOut];
                break;

                default:break;
            }
        }
        break;


#pragma mark APM
        case TestSectionAPM:
        {
            NSString* urlString = @"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json";
        //    NSString* urlString = @"http://www.bbc.co.uk/radio1/playlist.json";
        //    NSString* urlString = @"https://maps.googleapis.com/maps/api/geocode/json?address=Ebisu%20Garden%20Place,Tokyo";
        //    NSString* urlString = @"https://itunes.apple.com/search?term=Michael%20Jackson&entity=musicVideo";

            NSURL* URL = [NSURL URLWithString:urlString];
            NSMutableURLRequest* request= [NSMutableURLRequest requestWithURL:URL];

            NSURLResponse* response;
            NSError* error;

            switch (indexPath.row)
            {
                case 0: [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                break;

                case 1: [NSURLConnection sendAsynchronousRequest:request queue:NSOperationQueue.mainQueue completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
                        {
                            NSLog(@"sendAsynchronousRequest:queue:completionHandler: finished!");
                        }];
                break;

                case 2: [NSURLConnection connectionWithRequest:request delegate:self];
                break;

                case 3:
                {
                    #pragma clang diagnostic push
                    #pragma clang diagnostic ignored "-Wunused-variable"
                    NSURLConnection* testConnection = [NSURLConnection.alloc initWithRequest:request delegate:self];
                    #pragma clang diagnostic push
                }break;

                case 4:
                {
                    NSURLConnection * testConnection = [NSURLConnection.alloc initWithRequest:request delegate:self startImmediately:NO];
                    [testConnection start];
                }break;

                case 5:
                {
                    NSURLConnection * testConnection = [NSURLConnection.alloc initWithRequest:request delegate:self startImmediately:YES];
                }break;
                
                case 6:
                {
                    NSURLSessionDataTask* testTask = [NSURLSession.sharedSession dataTaskWithRequest:request];
                    [testTask resume];
                }break;
                
                case 7:
                {
                    NSURLSessionDataTask* testTask = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error)
                    {
                        NSLog(@"dataTaskWithRequest:completionHandler: finished!");
                    }];
                    [testTask resume];
                }break;
                
                case 8:
                {
                    NSURLSessionDataTask* testTask = [NSURLSession.sharedSession dataTaskWithURL:URL];
                    [testTask resume];
                }break;

                case 9:
                {
                    NSURLSessionDataTask* testTask = [NSURLSession.sharedSession dataTaskWithURL:URL completionHandler:^(NSData * data, NSURLResponse * response, NSError * error)
                    {
                        NSLog(@"dataTaskWithURL:completionHandler: finished!");
                    }];
                    [testTask resume];
                }break;

                case 10:
                {
                    NSURLSessionDownloadTask* testTask = [NSURLSession.sharedSession downloadTaskWithRequest:request];
                    [testTask resume];
                }break;
                
                case 11:
                {
                    NSURLSessionDownloadTask* testTask = [NSURLSession.sharedSession downloadTaskWithRequest:request completionHandler:^(NSURL * location, NSURLResponse * response, NSError * error)
                    {
                        NSLog(@"dataTaskWithRequest:completionHandler: finished!");
                    }];
                    [testTask resume];
                }break;
                
                case 12:
                {
                    NSURLSessionDownloadTask* testTask = [NSURLSession.sharedSession downloadTaskWithURL:URL];
                    [testTask resume];
                }break;

                case 13:
                {
                    NSURLSessionDownloadTask* testTask = [NSURLSession.sharedSession downloadTaskWithURL:URL completionHandler:^(NSURL * location, NSURLResponse * response, NSError * error)
                    {
                        NSLog(@"dataTaskWithURL:completionHandler: finished!");
                    }];
                    [testTask resume];
                }break;

                case 14: [Countly.sharedInstance addExceptionForAPM:@"http://finance.yahoo.com"];
                break;

                case 15: [Countly.sharedInstance removeExceptionForAPM:@"http://finance.yahoo.com"];
                break;

                default:break;
            }
        }
        break;


#pragma mark View Tracking
        case TestSectionViewTracking:
        {
            switch (indexPath.row)
            {
                case 0: Countly.sharedInstance.isAutoViewTrackingEnabled = NO;
                break;

                case 1: Countly.sharedInstance.isAutoViewTrackingEnabled = YES;
                break;

                case 2:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
                    TestModalViewController* tmvc = [storyboard instantiateViewControllerWithIdentifier:@"TestModalViewController"];
                    tmvc.title = @"MyViewControllerTitle";
                    [self presentViewController:tmvc animated:YES completion:nil];
                }break;

                case 3:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Countly" bundle:nil];
                    TestPushPopViewController* tppvc = [storyboard instantiateViewControllerWithIdentifier:@"TestPushPopViewController"];

                    UILabel* titleView = [UILabel.alloc initWithFrame:(CGRect){0,0,320,30}];
                    titleView.text = @"MyViewControllerCustomTitleView";
                    titleView.textAlignment = NSTextAlignmentCenter;
                    titleView.textColor = UIColor.redColor;
                    titleView.font = [UIFont systemFontOfSize:12];
                    tppvc.navigationItem.titleView = titleView;
                    UINavigationController* nc = [UINavigationController.alloc initWithRootViewController:tppvc];
                    nc.title = @"TestPushPopViewController";
                    [self presentViewController:nc animated:YES completion:nil];
                }break;

                case 4: [Countly.sharedInstance addExceptionForAutoViewTracking:NSStringFromClass(TestModalViewController.class)];
                break;

                case 5: [Countly.sharedInstance removeExceptionForAutoViewTracking:NSStringFromClass(TestModalViewController.class)];
                break;

                case 6: [Countly.sharedInstance addExceptionForAutoViewTracking:@"MyViewControllerTitle"];
                break;

                case 7: [Countly.sharedInstance removeExceptionForAutoViewTracking:@"MyViewControllerTitle"];
                break;

                case 8: [Countly.sharedInstance addExceptionForAutoViewTracking:@"MyViewControllerCustomTitleView"];
                break;

                case 9: [Countly.sharedInstance removeExceptionForAutoViewTracking:@"MyViewControllerCustomTitleView"];
                break;

                case 10: [Countly.sharedInstance reportView:@"ManualViewReportExample_MyMainView"];
                break;

                default: break;
            }
        }
        break;


#pragma mark Push Notifications
        case TestSectionPushNotifications:
        {
            switch (indexPath.row)
            {
                case 0: [Countly.sharedInstance askForNotificationPermission];
                break;

                case 1:
                {
                    UNAuthorizationOptions authorizationOptions = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
                    [Countly.sharedInstance askForNotificationPermissionWithOptions:authorizationOptions completionHandler:^(BOOL granted, NSError *error)
                    {
                        NSLog(@"Notification Permission Granted: %d", granted);
                        NSLog(@"Error: %@", error);
                    }];
                }break;

                case 2: [Countly.sharedInstance recordLocation:(CLLocationCoordinate2D){33.6789,43.1234}];
                break;

                case 3:
                {
                    NSDictionary* userInfo;     // notification dictionary
                    NSInteger buttonIndex = 1; 	// clicked button index
                                                // 1 for first action button
                                                // 2 for second action button
                                                // 0 for default action
                    [Countly.sharedInstance recordActionForNotification:userInfo clickedButtonIndex:buttonIndex];
                }break;

                default: break;
            }
        }
        break;


#pragma mark Multithreading
        case TestSectionMultithreading:
        {
            NSString* eventName = [@"MultithreadingEvent" stringByAppendingFormat:@"%d", (int)indexPath.row + 1];

            for (int i=0; i<15; i++)
            {
                dispatch_queue_t queue;
                if (indexPath.row >= 3)
                {
                    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                }
                else
                {
                    NSString* queueName = [@"ly.count.multithreading" stringByAppendingFormat:@"%d", i];
                    queue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_CONCURRENT);
                }

                NSDictionary* segmentation = @{@"k":[@"v"stringByAppendingFormat:@"%d", i]};

                dispatch_async(queue, ^
                {
                    [Countly.sharedInstance recordEvent:eventName segmentation:segmentation];
                    NSLog(@"Thread %d", i);
                });
            }
        }
        break;


#pragma mark Others
        case TestSectionOthers:
        {
            switch (indexPath.row)
            {
                case 0: [Countly.sharedInstance setCustomHeaderFieldValue:@"thisismyvalue"];
                break;

                case 1: [Countly.sharedInstance askForStarRating:^(NSInteger rating){ NSLog(@"rating %d",(int)rating); }];
                break;

                case 2: [Countly.sharedInstance setNewDeviceID:@"user@example.com" onServer:NO];
                break;

                case 3: [Countly.sharedInstance setNewDeviceID:CLYIDFV onServer:YES];
                break;

                case 4: [Countly.sharedInstance beginSession];
                break;

                case 5: [Countly.sharedInstance updateSession];
                break;

                case 6: [Countly.sharedInstance endSession];
                break;

                default: break;
            }
        }
        break;
        
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSLog(@"%s %@",__FUNCTION__,[connection description]);
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    NSLog(@"%s %@",__FUNCTION__,[connection description]);
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"%s %@",__FUNCTION__,[connection description]);
}


#pragma mark - Crash Tests


- (void)crashTest0
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(thisIsTheUnrecognizedSelectorCausingTheCrash)];
    #pragma clang diagnostic pop
}


- (void)crashTest1
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunused-variable"
    NSArray* anArray = @[@"one",@"two",@"three"];
    NSString* myCrashingString = anArray[5];
    #pragma clang diagnostic pop
}


- (void)crashTest2
{
    int *nullPointer = NULL;
    *nullPointer = 2017;
}


- (void)crashTest3
{
    CGRect aRect = (CGRect){0.0/0.0, 0.0, 100.0, 100.0};
    UIView *crashView = UIView.new;
    crashView.frame = aRect;
}


- (void)crashTest4
{
    NSAssert(0==1, @"This is the test assert that failed!");
}


- (void)crashTest5
{
    kill(getpid(), SIGABRT);
}


- (void)crashTest6
{
    __builtin_trap();
}

@end
