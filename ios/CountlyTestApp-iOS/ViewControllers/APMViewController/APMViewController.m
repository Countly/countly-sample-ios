// APMViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "APMViewController.h"
#import "Countly.h"

@implementation APMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"APM";

    self.tests = @[
        @{@"name": @"sendSynchronous", @"explanation": @""},
        @{@"name": @"sendAsynchronous", @"explanation": @""},
        @{@"name": @"connectionWithRequest", @"explanation": @""},
        @{@"name": @"initWithRequest", @"explanation": @""},
        @{@"name": @"initWithRequest:startImmediately NO", @"explanation": @""},
        @{@"name": @"initWithRequest:startImmediately YES", @"explanation": @""},
        @{@"name": @"dataTaskWithRequest", @"explanation": @""},
        @{@"name": @"dataTaskWithRequest:completionHandler", @"explanation": @""},
        @{@"name": @"dataTaskWithURL", @"explanation": @""},
        @{@"name": @"dataTaskWithURL:completionHandler", @"explanation": @""},
        @{@"name": @"downloadTaskWithRequest", @"explanation": @""},
        @{@"name": @"downloadTaskWithRequest:completionHandler", @"explanation": @""},
        @{@"name": @"downloadTaskWithURL", @"explanation": @""},
        @{@"name": @"downloadTaskWithURL:completionHandler", @"explanation": @""},
        @{@"name": @"Start Custom Trace", @"explanation": @"MyCustomTrace"},
        @{@"name": @"End Custom Trace", @"explanation": @"MyCustomTrace with metrics"},
        @{@"name": @"Cancel Custom Trace", @"explanation": @"MyCustomTrace"},
        @{@"name": @"Clear All Custom Traces", @"explanation": @""},
        @{@"name": @"App Loading Finished", @"explanation": @"Record app launch time"},
        @{@"name": @"Record Network Trace", @"explanation": @"Manual network trace recording"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    NSString *urlString = @"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json";
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

    NSURLResponse *returningResponse;
    NSError *returningError;

    switch (index)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case 0: [NSURLConnection sendSynchronousRequest:request returningResponse:&returningResponse error:&returningError]; break;

        case 1: [NSURLConnection sendAsynchronousRequest:request queue:NSOperationQueue.mainQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSLog(@"sendAsynchronousRequest:queue:completionHandler: finished!");
        }]; break;

        case 2: [NSURLConnection connectionWithRequest:request delegate:self]; break;

        case 3:
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
            NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
#pragma clang diagnostic pop
        } break;

        case 4:
        {
            NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
            [testConnection start];
        } break;

        case 5:
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
            NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
#pragma clang diagnostic pop
        } break;
#pragma clang diagnostic pop

        case 6:  { NSURLSessionDataTask *t = [NSURLSession.sharedSession dataTaskWithRequest:request]; [t resume]; } break;
        case 7:  { NSURLSessionDataTask *t = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) { NSLog(@"dataTaskWithRequest:completionHandler: finished!"); }]; [t resume]; } break;
        case 8:  { NSURLSessionDataTask *t = [NSURLSession.sharedSession dataTaskWithURL:URL]; [t resume]; } break;
        case 9:  { NSURLSessionDataTask *t = [NSURLSession.sharedSession dataTaskWithURL:URL completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) { NSLog(@"dataTaskWithURL:completionHandler: finished!"); }]; [t resume]; } break;
        case 10: { NSURLSessionDownloadTask *t = [NSURLSession.sharedSession downloadTaskWithRequest:request]; [t resume]; } break;
        case 11: { NSURLSessionDownloadTask *t = [NSURLSession.sharedSession downloadTaskWithRequest:request completionHandler:^(NSURL *l, NSURLResponse *r, NSError *e) { NSLog(@"downloadTaskWithRequest:completionHandler: finished!"); }]; [t resume]; } break;
        case 12: { NSURLSessionDownloadTask *t = [NSURLSession.sharedSession downloadTaskWithURL:URL]; [t resume]; } break;
        case 13: { NSURLSessionDownloadTask *t = [NSURLSession.sharedSession downloadTaskWithURL:URL completionHandler:^(NSURL *l, NSURLResponse *r, NSError *e) { NSLog(@"downloadTaskWithURL:completionHandler: finished!"); }]; [t resume]; } break;

        case 14: [Countly.sharedInstance startCustomTrace:@"MyCustomTrace"]; break;
        case 15: [Countly.sharedInstance endCustomTrace:@"MyCustomTrace" metrics:@{@"metric1": @42}]; break;
        case 16: [Countly.sharedInstance cancelCustomTrace:@"MyCustomTrace"]; break;
        case 17: [Countly.sharedInstance clearAllCustomTraces]; break;
        case 18: [Countly.sharedInstance appLoadingFinished]; break;

        case 19:
        {
            long long startTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000) - 500;
            long long endTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
            [Countly.sharedInstance recordNetworkTrace:@"custom_api_call" requestPayloadSize:512 responsePayloadSize:1024 responseStatusCode:200 startTime:startTime endTime:endTime];
        } break;

        default: break;
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {}

@end
