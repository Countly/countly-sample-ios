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
#import "EYCrashTesting.h"

@interface MainViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tbl_main;
@property (nonatomic) NSArray* tests;
@end

typedef enum : NSUInteger
{
    TestSectionCustomEvents,
    TestSectionCrashReporting,
    TestSectionUserDetails,
    TestSectionAPM,
    TestSectionViewTracking,
    TestSectionPushNotifications,
    TestSectionLocation,
    TestSectionMultithreading,
    TestSectionConsents,
    TestSectionRemoteConfig,
    TestSectionOthers
} TestSection;

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //copy pictures from App Bundle to Documents directory, to use later for User Details picture upload tests.
    NSURL* documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;

    NSArray* fileTypes = @[@"gif", @"jpg", @"png"];
    for (NSString* fileType in fileTypes)
    {
        NSURL* bundleFileURL = [NSBundle.mainBundle URLForResource:@"SamplePicture" withExtension:fileType];
        NSURL* destinationURL = [documentsDirectory URLByAppendingPathComponent:bundleFileURL.lastPathComponent];
        [NSFileManager.defaultManager copyItemAtURL:bundleFileURL toURL:destinationURL error:nil];
    }

    self.tests =
    @[
        @{
            @"name": @"Custom Events",
            @"tests":
            @[
                @{
                    @"name": @"Create a Custom Event",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Record Event",
                    @"explanation": @"TestEventA",
                },
                @{
                    @"name": @"Record Event with Count",
                    @"explanation": @"TestEventA  c:5",
                },
                @{
                    @"name": @"Record Event with Sum",
                    @"explanation": @"TestEventB  s:1.99",
                },
                @{
                    @"name": @"Record Event with Duration",
                    @"explanation": @"TestEventB  d:3.14",
                },
                @{
                    @"name": @"Record Event with Count & Sum",
                    @"explanation": @"TestEventB  c:5 s:1.99",
                },
                @{
                    @"name": @"Record Event with Segmentation",
                    @"explanation": @"TestEventC  sg:{k:v}",
                },
                @{
                    @"name": @"Record Event with Segmentation & Count",
                    @"explanation": @"TestEventC  sg:{k:v}  c:5",
                },
                @{
                    @"name": @"Record Event with Segmentation, Count & Sum",
                    @"explanation": @"TestEventD  sg:{k:v}  c:5  s:1.99",
                },
                @{
                    @"name": @"Record Event with Segmentation, Count, Sum & Dur.",
                    @"explanation": @"TestEventD  sg:{k:v}  c:5  s:1.99  d:0.314",
                },
                @{
                    @"name": @"Start Event",
                    @"explanation": @"timed-event",
                },
                @{
                    @"name": @"End Event",
                    @"explanation": @"timed-event",
                },
                @{
                    @"name": @"End Event with Segmentation, Count & Sum",
                    @"explanation": @"timed-event  sg:{k:v}  c:1  s:0",
                },
            ],
        },

        @{
            @"name": @"Crash Reporting",
            @"tests":
            @[
                @{
                    @"name": @"Unrecognized Selector",
                    @"explanation": @"thisIsTheUnrecognizedSelectorCausingTheCrash",
                },
                @{
                    @"name": @"Out of Bounds",
                    @"explanation": @"5th element in a 3 elements array",
                },
                @{
                    @"name": @"NULL Pointer",
                    @"explanation": @"Dereference",
                },
                @{
                    @"name": @"Invalid Geometry",
                    @"explanation": @"CALayer position contains nan",
                },
                @{
                    @"name": @"Raise Custom Exception",
                    @"explanation": @"This is the exception!",
                },
                @{
                    @"name": @"kill",
                    @"explanation": @"with SIGABRT",
                },
                @{
                    @"name": @"__builtin_trap",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Access to a Non-Object",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Message a Released Object",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Write to Read-Only Memory",
                    @"explanation": @"using function pointer aFunction",
                },
                @{
                    @"name": @"Stack Overflow",
                    @"explanation": @"infinite recursive call",
                },
                @{
                    @"name": @"abort",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Custom Crash Log",
                    @"explanation": @"This is a custom crash log!",
                },
                @{
                    @"name": @"Record Handled Exception",
                    @"explanation": @"n:MyException  r:MyReason  d:{key:value}",
                },
                @{
                    @"name": @"Record Handled Exception with Stack Trace",
                    @"explanation": @"n:MyExc  r:MyReason  d:{key:value} and stack trace",
                },
                @{
                    @"name": @"Record Unhandled Exception with Stack Trace",
                    @"explanation": @"n:MyUnhandledExc  r:MyReason  d:{key:value} and stack trace",
                },
            ],
        },

        @{
            @"name": @"User Details",
            @"tests":
            @[
                @{
                    @"name": @"Record User Details",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Custom Property Modifiers",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Dummy User Details",
                    @"explanation": @"Dummy John Doe data",
                },
                @{
                    @"name": @"Delete Some User Details by Nulling",
                    @"explanation": @"email, birthYear, gender",
                },
                @{
                    @"name": @"Some Custom Property Modifiers 1",
                    @"explanation": @"set-incrementBy-push-save",
                },
                @{
                    @"name": @"Some Custom Property Modifiers 2",
                    @"explanation": @"multiply-unset-pull-save",
                },
                @{
                    @"name": @"User Logged in",
                    @"explanation": @"OwnUserID",
                },
                @{
                    @"name": @"User Logged out",
                    @"explanation": @"switch back to IDFV and start new session",
                },
            ],
        },

        @{
            @"name": @"APM",
            @"tests":
            @[
                @{
                    @"name":@"sendSynchronous",
                    @"explanation": @"",
                },
                @{
                    @"name":@"sendAsynchronous",
                    @"explanation": @"",
                },
                @{
                    @"name":@"connectionWithRequest",
                    @"explanation": @"",
                },
                @{
                    @"name":@"initWithRequest",
                    @"explanation": @"",
                },
                @{
                    @"name":@"initWithRequest:startImmediately NO",
                    @"explanation": @"",
                },
                @{
                    @"name":@"initWithRequest:startImmediately YES",
                    @"explanation": @"",
                },
                @{
                    @"name":@"dataTaskWithRequest",
                    @"explanation": @"",
                },
                @{
                    @"name":@"dataTaskWithRequest:completionHandler",
                    @"explanation": @"",
                },
                @{
                    @"name":@"dataTaskWithURL",
                    @"explanation": @"",
                },
                @{
                    @"name":@"dataTaskWithURL:completionHandler",
                    @"explanation": @"",
                },
                @{
                    @"name":@"downloadTaskWithRequest",
                    @"explanation": @"",
                },
                @{
                    @"name":@"downloadTaskWithRequest:completionHandler",
                    @"explanation": @"",
                },
                @{
                    @"name":@"downloadTaskWithURL",
                    @"explanation": @"",
                },
                @{
                    @"name":@"downloadTaskWithURL:completionHandler",
                    @"explanation": @"",
                },
                @{
                    @"name":@"Add Exception URL",
                    @"explanation": @"http://finance.yahoo.com",
                },
                @{
                    @"name":@"Remove Exception URL",
                    @"explanation": @"http://finance.yahoo.com",
                },
            ],
        },

        @{
            @"name": @"View Tracking",
            @"tests":
            @[
                @{
                    @"name": @"Deactivate AutoViewTracking",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Activate AutoViewTracking",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Present Modal View Controller",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Push / Pop with Navigation Controller ",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Add Exception with Class Name",
                    @"explanation": @"TestModalViewController.class",
                },
                @{
                    @"name": @"Remove Exception with Class Name",
                    @"explanation": @"TestModalViewController.class",
                },
                @{
                    @"name": @"Add Exception with Title",
                    @"explanation": @"MyViewControllerTitle",
                },
                @{
                    @"name": @"Remove Exception with Title",
                    @"explanation": @"MyViewControllerTitle",
                },
                @{
                    @"name": @"Add Exception with Custom titleView",
                    @"explanation": @"MyViewControllerCustomTitleView",
                },
                @{
                    @"name": @"Remove Exception with Custom titleView",
                    @"explanation": @"MyViewControllerCustomTitleView",
                },
                @{
                    @"name": @"Report View Manually",
                    @"explanation": @"ManualViewReportExample_MyMainView",
                },
            ],
        },

        @{
            @"name": @"Push Notifications",
            @"tests":
            @[
                @{
                    @"name": @"Ask for Notification Permission",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Ask for Notification Permission with Completion Handler",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Record Push Notification Action",
                    @"explanation": @"for manually handled push notifications",
                },
            ],
        },

        @{
            @"name": @"Location",
            @"tests":
            @[
                @{
                    @"name": @"Record Location",
                    @"explanation": @"33.6789, 43.1234",
                },
                @{
                    @"name": @"Record City and Country",
                    @"explanation": @"Tokyo - JP",
                },
                @{
                    @"name": @"Record IP Address",
                    @"explanation": @"1.2.3.4",
                },
                @{
                    @"name": @"Disable Location Info",
                    @"explanation": @"",
                },
            ],
        },

        @{
            @"name": @"Multithreading",
            @"tests":
            @[
                @{
                    @"name": @"Own Queue Multithread Testing 1",
                    @"explanation": @"MultithreadingEvent1 on 15 threads",
                },
                @{
                    @"name": @"Own Queue Multithread Testing 2",
                    @"explanation": @"MultithreadingEvent3 on 15 threads",
                },
                @{
                    @"name": @"Own Queue Multithread Testing 3",
                    @"explanation": @"MultithreadingEvent3 on 15 threads",
                },
                @{
                    @"name": @"Global Queue Multithread Testing 1",
                    @"explanation": @"MultithreadingEvent4",
                },
                @{
                    @"name": @"Global Queue Multithread Testing 2",
                    @"explanation": @"MultithreadingEvent5",
                },
                @{
                    @"name": @"Global Queue Multithread Testing 3",
                    @"explanation": @"MultithreadingEvent6",
                },
            ],
        },

        @{
            @"name": @"Consents",
            @"tests":
            @[
                @{
                    @"name": @"Give for Sessions",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for Events",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for UserDetails",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for CrashReporting",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for PushNotifications",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for Location",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for ViewTracking",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for Attribution",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for StarRating",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for AppleWatch",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Give for All the Features",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for Sessions",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for Events",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for UserDetails",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for CrashReporting",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for PushNotifications",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for Location",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for ViewTracking",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for Attribution",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for StarRating",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for AppleWatch",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Cancel for All the Features",
                    @"explanation": @"",
                },
            ],
        },

        @{
            @"name": @"Remote Config",
            @"tests":
            @[
                @{
                    @"name": @"Access a Remote Config value",
                    @"explanation": @"for `level_difficulty` key",
                },
                @{
                    @"name": @"Update all Remote Config values",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Update some Remote Config values",
                    @"explanation": @"for `a` and `b` keys",
                },
                @{
                    @"name": @"Update all but some Remote Config values",
                    @"explanation": @"except `a` and `b` keys",
                },
            ]
        },

        @{
            @"name": @"Others",
            @"tests":
            @[
                @{
                    @"name": @"Set Custom Header Field Value",
                    @"explanation": @"thisismyvalue",
                },
                @{
                    @"name": @"Ask for Star-Rating",
                    @"explanation": @"",
                },
                @{
                    @"name": @"Set New Device ID",
                    @"explanation": @"user@example.com",
                },
                @{
                    @"name": @"Set New Device ID with Server Merge",
                    @"explanation": @"IDFV",
                },
                @{
                    @"name": @"Begin Session",
                    @"explanation": @"manual session handling",
                },
                @{
                    @"name": @"Update Session",
                    @"explanation": @"manual session handling",
                },
                @{
                    @"name": @"End Session",
                    @"explanation": @"manual session handling",
                },
                @{
                    @"name": @"Present Feedback Widget",
                    @"explanation": @"Feedback Widget ID needs to be hardcoded",
                },
            ],
        },
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
    return self.tests.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* tests = self.tests[section][@"tests"];
    return tests.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* sectionName = self.tests[section][@"name"];

    UIView* headerView = UIView.new;
    headerView.backgroundColor = UIColor.grayColor;

    UIImageView* imageView = [UIImageView.alloc initWithFrame:(CGRect){15,6,12,12}];
    imageView.image = [UIImage imageNamed:[sectionName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [headerView addSubview:imageView];

    UILabel* label = [UILabel.alloc initWithFrame:(CGRect){33,0,320,24}];
    label.font = [UIFont fontWithName:@"AvenirNext-bold" size:14];
    label.textColor = UIColor.whiteColor;
    label.text = sectionName;
    [headerView addSubview:label];

    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kCountlyCellIdentifier = @"kCountlyCellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCountlyCellIdentifier];
    
    if (!cell)
    {
        cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCountlyCellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-medium" size:14];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Menlo" size:11];
    }

    NSArray* tests = self.tests[indexPath.section][@"tests"];
    cell.textLabel.text = tests[indexPath.row][@"name"];
    cell.detailTextLabel.text = tests[indexPath.row][@"explanation"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* sectionName = self.tests[indexPath.section][@"name"];
    NSArray* tests = self.tests[indexPath.section][@"tests"];
    NSLog(@"Test: %@ - %@", sectionName, tests[indexPath.row][@"name"]);

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

                case 6: [Countly.sharedInstance recordEvent:@"TestEventC" segmentation:@{@"k": @"v"}];
                break;

                case 7: [Countly.sharedInstance recordEvent:@"TestEventC" segmentation:@{@"k": @"v"} count:5];
                break;

                case 8: [Countly.sharedInstance recordEvent:@"TestEventD" segmentation:@{@"k": @"v"} count:5 sum:1.99];
                break;

                case 9: [Countly.sharedInstance recordEvent:@"TestEventD" segmentation:@{@"k": @"v"} count:5 sum:1.99 duration:0.314];
                break;

                case 10: [Countly.sharedInstance startEvent:@"timed-event"];
                break;

                case 11: [Countly.sharedInstance endEvent:@"timed-event"];
                break;

                case 12: [Countly.sharedInstance endEvent:@"timed-event" segmentation:@{@"k": @"v"} count:1 sum:0];
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
                case 0:  [EYCrashTesting crashTest0];  break;
                case 1:  [EYCrashTesting crashTest1];  break;
                case 2:  [EYCrashTesting crashTest2];  break;
                case 3:  [EYCrashTesting crashTest3];  break;
                case 4:  [EYCrashTesting crashTest4];  break;
                case 5:  [EYCrashTesting crashTest5];  break;
                case 6:  [EYCrashTesting crashTest6];  break;
                case 7:  [EYCrashTesting crashTest7];  break;
                case 8:  [EYCrashTesting crashTest8];  break;
                case 9:  [EYCrashTesting crashTest9];  break;
                case 10: [EYCrashTesting crashTest10]; break;
                case 11: [EYCrashTesting crashTest11]; break;

                case 12: [Countly.sharedInstance recordCrashLog:@"This is a custom crash log!"];
                break;

                case 13:
                {
                    NSException* myException = [NSException exceptionWithName:@"MyException" reason:@"MyReason" userInfo:@{@"key": @"value"}];
                    [Countly.sharedInstance recordHandledException:myException];
                }break;

                case 14:
                {
                    NSException* myException = [NSException exceptionWithName:@"MyExc" reason:@"MyReason" userInfo:@{@"key": @"value"}];
                    [Countly.sharedInstance recordHandledException:myException withStackTrace:[NSThread callStackSymbols]];
                }break;

                case 15:
                {
                    NSException* myException = [NSException exceptionWithName:@"MyUnhandledExc" reason:@"MyReason" userInfo:@{@"key": @"value"}];
                    [Countly.sharedInstance recordUnhandledException:myException withStackTrace:[NSThread callStackSymbols]];
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
                    Countly.user.custom = @{@"testkey1": @"testvalue1", @"testkey2": @"testvalue2"};

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

            NSURLResponse* returningResponse;
            NSError* returningError;

            switch (indexPath.row)
            {
                case 0: [NSURLConnection sendSynchronousRequest:request returningResponse:&returningResponse error:&returningError];
                break;

                case 1: [NSURLConnection sendAsynchronousRequest:request queue:NSOperationQueue.mainQueue completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
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
                case 0: Countly.sharedInstance.isAutoViewTrackingActive = NO;
                break;

                case 1: Countly.sharedInstance.isAutoViewTrackingActive = YES;
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

                case 10: [Countly.sharedInstance recordView:@"ManualViewReportExample_MyMainView"];
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
                    if (@available(iOS 10.0, *))
                    {
                        UNAuthorizationOptions authorizationOptions = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
                        [Countly.sharedInstance askForNotificationPermissionWithOptions:authorizationOptions completionHandler:^(BOOL granted, NSError *error)
                        {
                            NSLog(@"Notification Permission Granted: %d", granted);
                            NSLog(@"Error: %@", error);
                        }];
                    }
                }break;

                case 2:
                {
                    NSDictionary* userInfo = NSDictionary.new;     // this should be the notification dictionary
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


#pragma mark Location
        case TestSectionLocation:
        {
            switch (indexPath.row)
            {
                case 0: [Countly.sharedInstance recordLocation:(CLLocationCoordinate2D){33.6789,43.1234}];
                break;

                case 1: [Countly.sharedInstance recordCity:@"Tokyo" andISOCountryCode:@"JP"];
                break;

                case 2: [Countly.sharedInstance recordIP:@"1.2.3.4"];
                break;

                case 3: [Countly.sharedInstance disableLocationInfo];
                break;

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


#pragma mark Consents
        case TestSectionConsents:
        {
            switch (indexPath.row)
            {
                case 0: [Countly.sharedInstance giveConsentForFeature:CLYConsentSessions];
                break;

                case 1: [Countly.sharedInstance giveConsentForFeature:CLYConsentEvents];
                break;

                case 2: [Countly.sharedInstance giveConsentForFeature:CLYConsentUserDetails];
                break;

                case 3: [Countly.sharedInstance giveConsentForFeature:CLYConsentCrashReporting];
                break;

                case 4: [Countly.sharedInstance giveConsentForFeature:CLYConsentPushNotifications];
                break;

                case 5: [Countly.sharedInstance giveConsentForFeature:CLYConsentLocation];
                break;

                case 6: [Countly.sharedInstance giveConsentForFeature:CLYConsentViewTracking];
                break;

                case 7: [Countly.sharedInstance giveConsentForFeature:CLYConsentAttribution];
                break;

                case 8: [Countly.sharedInstance giveConsentForFeature:CLYConsentStarRating];
                break;

                case 9: [Countly.sharedInstance giveConsentForFeature:CLYConsentAppleWatch];
                break;

                case 10: [Countly.sharedInstance giveConsentForAllFeatures];
                break;

                case 11: [Countly.sharedInstance cancelConsentForFeature:CLYConsentSessions];
                break;

                case 12: [Countly.sharedInstance cancelConsentForFeature:CLYConsentEvents];
                break;

                case 13: [Countly.sharedInstance cancelConsentForFeature:CLYConsentUserDetails];
                break;

                case 14: [Countly.sharedInstance cancelConsentForFeature:CLYConsentCrashReporting];
                break;

                case 15: [Countly.sharedInstance cancelConsentForFeature:CLYConsentPushNotifications];
                break;

                case 16: [Countly.sharedInstance cancelConsentForFeature:CLYConsentLocation];
                break;

                case 17: [Countly.sharedInstance cancelConsentForFeature:CLYConsentViewTracking];
                break;

                case 18: [Countly.sharedInstance cancelConsentForFeature:CLYConsentAttribution];
                break;

                case 19: [Countly.sharedInstance cancelConsentForFeature:CLYConsentStarRating];
                break;

                case 20: [Countly.sharedInstance cancelConsentForFeature:CLYConsentAppleWatch];
                break;

                case 21: [Countly.sharedInstance cancelConsentForAllFeatures];
                break;

                default: break;
            }
        }
        break;


#pragma mark Remote Config
        case TestSectionRemoteConfig:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    id levelDifficulty = [Countly.sharedInstance remoteConfigValueForKey:@"level_difficulty"];
                    NSLog(@"Level Difficulty: %@", levelDifficulty);
                }
                break;

                case 1:
                {
                    [Countly.sharedInstance updateRemoteConfigWithCompletionHandler:^(NSError * error)
                    {
                        if (!error)
                        {
                            NSLog(@"Remote Config is updated and ready to use!");
                        }
                        else
                        {
                            NSLog(@"There is an error while updating Remote Config:\n%@", error);
                        }
                    }];
                }
                break;

                case 2:
                {
                    [Countly.sharedInstance updateRemoteConfigOnlyForKeys:@[@"a", @"b"] completionHandler:^(NSError * error)
                    {
                        if (!error)
                        {
                            NSLog(@"Remote Config is updated and ready to use!");
                        }
                        else
                        {
                            NSLog(@"There is an error while updating Remote Config:\n%@", error);
                        }
                    }];
                }
                break;

                case 3:
                {
                    [Countly.sharedInstance updateRemoteConfigExceptForKeys:@[@"a", @"b"] completionHandler:^(NSError * error)
                    {
                        if (!error)
                        {
                            NSLog(@"Remote Config is updated and ready to use!");
                        }
                        else
                        {
                            NSLog(@"There is an error while updating Remote Config:\n%@", error);
                        }
                    }];
                }
                break;
            }
        }


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

                case 7:
                    [Countly.sharedInstance presentFeedbackWidgetWithID:@"FEEDBACK_WIDGET_ID" completionHandler:^(NSError * _Nonnull error)
                    {
                        if (error)
                            NSLog(@"Feedback widget presentation failed: \n%@\n%@", error.localizedDescription, error.userInfo);
                        else
                            NSLog(@"Feedback widget presented successfully");
                    }];
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

@end


//- (id)remoteConfigValueForKey:(NSString *)key;
//- (void)updateRemoteConfigWithCompletionHandler:(void (^)(NSError * error))completionHandler;
//- (void)updateRemoteConfigOnlyForKeys:(NSArray *)keys completionHandler:(void (^)(NSError * error))completionHandler;
//- (void)updateRemoteConfigExceptForKeys:(NSArray *)omitKeys completionHandler:(void (^)(NSError * error))completionHandler;
