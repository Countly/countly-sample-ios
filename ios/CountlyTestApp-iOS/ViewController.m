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

//uncomment these lines (and some in main.m) for displaying console logs inside the test app
//    self.logFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"logfile.log"];
//    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.1];

    //copy pictures from App Bundle to Documents directory, to use later for User Details picture upload tests.
    NSURL* documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;

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
    typedef enum:NSInteger
    {
        TestPageCustomEvents,
        TestPageCrashReporting,
        TestPageUserDetails,
        TestPageAPM,
        TestPageCount
    } TestPages;
    
    NSInteger startPage = TestPageCustomEvents; //start page of testing app can be set here.

    self.scr_main.contentSize = (CGSize){self.scr_main.bounds.size.width*TestPageCount,self.scr_main.bounds.size.height};
    self.scr_main.contentOffset = CGPointMake(self.scr_main.bounds.size.width*startPage, 0);
    [self scrollViewDidEndDecelerating:self.scr_main];

    [super viewWillAppear:animated];
}



#pragma mark -
- (IBAction)onClick_event:(id)sender
{
    NSLog(@"%s tag: %li",__FUNCTION__,(long)[sender tag]);

    switch ([sender tag])
    {
        case 1:
            [Countly.sharedInstance recordEvent:@"button-click"];
        break;

        case 2:
            [Countly.sharedInstance recordEvent:@"button-click" count:5];
        break;

        case 3:
            [Countly.sharedInstance recordEvent:@"button-click" sum:1.99];
        break;

        case 4:
            [Countly.sharedInstance recordEvent:@"button-click" duration:3.14];
        break;

        case 5:
            [Countly.sharedInstance recordEvent:@"button-click" segmentation:@{@"k" : @"v"}];
        break;

        case 6:
            [Countly.sharedInstance recordEvent:@"button-click" segmentation:@{@"k" : @"v"} count:5];
        break;

        case 7:
            [Countly.sharedInstance recordEvent:@"button-click" segmentation:@{@"k" : @"v"} count:5 sum:1.99];
        break;

        case 8:
            [Countly.sharedInstance recordEvent:@"button-click" segmentation:@{@"k" : @"v"} count:5 sum:1.99 duration:0.314];
        break;
        
        case 9:
            [Countly.sharedInstance startEvent:@"timed-event"];
        break;

        case 10:
            [Countly.sharedInstance endEvent:@"timed-event" segmentation:@{@"k" : @"v"} count:1 sum:0];
        break;
        
        default:break;
    }
}


- (IBAction)onClick_crash:(id)sender
{
    NSLog(@"%s tag: %li",__FUNCTION__,(long)[sender tag]);

    switch ([sender tag])
    {
        case 11:
        {
            [CountlyCrashReporter.sharedInstance crashTest];
        }break;

        case 12:
        {
            [CountlyCrashReporter.sharedInstance crashTest2];
        }break;

        case 13:
        {
            [CountlyCrashReporter.sharedInstance crashTest3];
        }break;

        case 14:
        {
            [CountlyCrashReporter.sharedInstance crashTest4];
        }break;

        default: break;
    }
}


- (IBAction)onClick_userDetails:(id)sender
{
    NSLog(@"%s tag: %li",__FUNCTION__,(long)[sender tag]);
    
    switch ([sender tag])
    {
        case 21:
        {
            NSURL* documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
            NSString* localImagePath = [documentsDirectory.absoluteString stringByAppendingPathComponent:@"SamplePicture.jpg"];
            // SamplePicture.png or SamplePicture.gif can be used too.
        
            CountlyUserDetails.sharedInstance.name = @"John Doe";
            CountlyUserDetails.sharedInstance.email = @"john@doe.com";
            CountlyUserDetails.sharedInstance.birthYear = 1970;
            CountlyUserDetails.sharedInstance.organization = @"United Nations";
            CountlyUserDetails.sharedInstance.gender = @"M";
            CountlyUserDetails.sharedInstance.phone = @"+0123456789";
            CountlyUserDetails.sharedInstance.pictureURL = @"http://example.com/examplepicture.jpg";
            CountlyUserDetails.sharedInstance.pictureLocalPath = localImagePath;
            CountlyUserDetails.sharedInstance.custom = @{@"testkey1":@"testvalue1",@"testkey2":@"testvalue2"};
        
            [CountlyUserDetails.sharedInstance recordUserDetails];
        }break;
        
        case 22:
        {
            [Countly.sharedInstance recordLocation:(CLLocationCoordinate2D){33.6789,43.1234}];
        }break;
        
        default:break;
    }
}


- (IBAction)onClick_APM:(id)sender
{
    NSLog(@"%s tag: %li",__FUNCTION__,(long)[sender tag]);

    NSString* urlString = @"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json";
//    NSString* urlString = @"http://www.bbc.co.uk/radio1/playlist.json";
//    NSString* urlString = @"https://maps.googleapis.com/maps/api/geocode/json?address=Ebisu%20Garden%20Place,Tokyo";
//    NSString* urlString = @"https://itunes.apple.com/search?term=Michael%20Jackson&entity=musicVideo";

    NSURL* URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request= [NSMutableURLRequest requestWithURL:URL];

    NSURLResponse* response;
    NSError* error;
        
    switch ([sender tag])
    {
        case 31:
        {
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        }break;

        case 32:
        {
            [NSURLConnection sendAsynchronousRequest:request queue:NSOperationQueue.mainQueue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)
            {
            
            }];
        }break;
        
        case 33:
        {
            [NSURLConnection connectionWithRequest:request delegate:self];
        }break;

        case 34:
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunused-variable"
            NSURLConnection* testConnection = [NSURLConnection.alloc initWithRequest:request delegate:self];
            #pragma clang diagnostic push
        }break;

        case 35:
        {
            [request setHTTPMethod:@"POST"];
            [request addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField: @"Content-Type"];
            [request setHTTPBody:[@"testKey1=testValue1&testKey2=testValue2" dataUsingEncoding:NSUTF8StringEncoding]];

            NSURLConnection * testConnection = [NSURLConnection.alloc initWithRequest:request delegate:self startImmediately:YES];
            [testConnection start];
        }break;

        case 36:
        {
/*
            NSURLSessionDataTask* testTask = [NSURLSession.sharedSession dataTaskWithRequest:request
                                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
            {
                NSLog(@"dataTaskWithRequest finished!");
            }];

            NSURLSessionDataTask* testTask = [NSURLSession.sharedSession dataTaskWithURL:URL
                                                                                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
            {
                NSLog(@"dataTaskWithURL finished!");
            }];

            NSURLSessionDownloadTask* testTask = [NSURLSession.sharedSession downloadTaskWithRequest:request
                                                                                              completionHandler:^(NSURL * _Nullable location,
                                                                                                                  NSURLResponse * _Nullable response,
                                                                                                                  NSError * _Nullable error)
            {
                  NSLog(@"downloadTaskWithRequest finished!");
            }];
*/
            NSURLSessionDataTask* testTask = [NSURLSession.sharedSession dataTaskWithRequest:request];

            [testTask resume];
//          [testTask performSelector:@selector(resume) withObject:nil afterDelay:5];
        
        }break;

        case 37:
        {
            [Countly.sharedInstance addExceptionForAPM:@"http://finance.yahoo.com"];
        }break;

        case 38:
        {
            [Countly.sharedInstance removeExceptionForAPM:@"http://finance.yahoo.com"];
        }break;

        default:break;
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
    NSError* fileError;
    
    NSData *d = [NSData dataWithContentsOfFile:self.logFilePath options:0 error:&fileError];
    NSString *s = [NSString.alloc initWithData:d encoding:NSUTF8StringEncoding];
    
    if(![s isEqualToString:@""])
        self.txt_log.text = s;
    
    UIScrollView* textViewScroll = (UIScrollView*)self.txt_log;
    
    if (textViewScroll.contentOffset.y >= textViewScroll.contentSize.height - textViewScroll.bounds.size.height)
    {
        NSRange myRange = NSMakeRange(self.txt_log.text.length, 0);
       [self.txt_log scrollRangeToVisible:myRange];
    }

    s = nil;
    
    [self performSelector:@selector(updateLogs) withObject:nil afterDelay:0.2];
}

#pragma mark -

-(void)connection:(NSURLConnection *)connection didFailWithError:(nonnull NSError *)error
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