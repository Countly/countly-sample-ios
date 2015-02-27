//
// ViewController.h
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "ViewController.h"
#import "Countly.h"

@interface ViewController ()
@property (strong, nonatomic) NSString *logFilePath;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL* documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;

    //set log path to see NSLog's within the app
    self.logFilePath = [documentsDirectory.absoluteString stringByAppendingPathComponent:@"logfile.log"];
    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.0];

    //copy pictures from App Bundle to Documents directory, to use later for User Details picture upload tests.
    NSArray *fileTypes = @[@"gif",@"jpg",@"png"];
    [fileTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        NSURL* bundleFileURL = [NSBundle.mainBundle URLForResource:@"SamplePicture" withExtension:((NSString*)obj).lowercaseString];
        NSURL* destinationURL = [documentsDirectory URLByAppendingPathComponent:bundleFileURL.lastPathComponent];
        [NSFileManager.defaultManager copyItemAtURL:bundleFileURL toURL:destinationURL error:nil];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    self.scr_main.contentSize = (CGSize){self.scr_main.bounds.size.width*3,self.scr_main.bounds.size.height};
    [super viewWillAppear:animated];
}



#pragma mark -
- (IBAction)onClick_event:(id)sender
{
    NSLog(@"%s tag: %li",__FUNCTION__,(long)[sender tag]);

    switch ([sender tag])
    {
        case 1: [[Countly sharedInstance] recordEvent:@"button-click" count:1];
            break;

        case 2: [[Countly sharedInstance] recordEvent:@"button-click" count:1 sum:1.99];
            break;

        case 3: [[Countly sharedInstance] recordEvent:@"button-click" segmentation:@{@"seg_test" : @"seg_value"} count:1];
            break;

        case 4: [[Countly sharedInstance] recordEvent:@"button-click" segmentation:@{@"seg_test" : @"seg_value"} count:1 sum:1.99];
            break;
            
            
//NOTE: requires crashreporting branch
//        case 11:
//                CountlyCrashLog(@"pressed the first crash button!");
//                [self performSelector:@selector(thisIsTheUnrecognizedSelectorWhichCausesTheCrash)];
//            break;
//            
//        case 12:
//                CountlyCrashLog(@"pressed the second crash button!");
//                {NSArray *a = @[@"one",@"two",@"three"]; a = @[a[3+arc4random()%10000]];}
//            break;
//            
//        case 13:
//                CountlyCrashLog(@"pressed the third crash button!");
//                {int *p = NULL; *p = 1970;}
//            break;
//            
//        case 14:
//                 CountlyCrashLog(@"pressed the fourth crash button!");
//                 {CGRect p = (CGRect){0.0/0.0, 0.0, 100.0, 100.0}; UIView *crashView = UIView.new; crashView.frame =p;}
//            break;
            
            
        case 21:
        {
            ;
            NSURL* documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
            NSString* localImagePath = [documentsDirectory.absoluteString stringByAppendingPathComponent:@"SamplePicture.jpg"];
            
            [Countly.sharedInstance recordUserDetails:@{
                                                        kCLYUserName:@"John Doe",
                                                        kCLYUserEmail:@"john@doe.com",
                                                        kCLYUserBirthYear:@1970,
                                                        kCLYUserOrganization:@"UN",
                                                        kCLYUserGender:@"M",
                                                        kCLYUserPhone:@"+90123456789",
                                                      //kCLYUserPicture:@"http://example.com/examplepicture.jpg",
                                                        kCLYUserCustom:@{@"testkey1":@"testvalue1",@"testkey2":@"testvalue2"},
                                                        kCLYUserPicturePath:localImagePath
                                                        }];
        }break;
            
        default:
            break;
    }
}

#pragma mark -

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pgc_main.currentPage = (NSInteger)self.scr_main.contentOffset.x/self.scr_main.frame.size.width;
}

#pragma mark -

-(void)updateLogs
{
    NSData *d = [NSData dataWithContentsOfFile:self.logFilePath];
    NSString *s = [NSString.alloc initWithData:d encoding:NSUTF8StringEncoding];
    
    if(![s isEqualToString:@""])
        self.txt_log.text = s;
    
    NSRange myRange=NSMakeRange(self.txt_log.text.length, 0);
    [self.txt_log scrollRangeToVisible:myRange];

    s = nil;
    
    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.2];
}
@end
