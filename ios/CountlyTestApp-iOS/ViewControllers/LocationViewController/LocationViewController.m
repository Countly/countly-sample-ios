// LocationViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "LocationViewController.h"
#import "Countly.h"

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Location";

    self.tests = @[
        @{@"name": @"Record Location", @"explanation": @"LatLong: 33.6789, 43.1234, City: Tokyo - JP, IP: 1.2.3.4"},
        @{@"name": @"Disable Location Info", @"explanation": @""},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: [Countly.sharedInstance recordLocation:(CLLocationCoordinate2D){33.6789, 43.1234} city:@"Tokyo" ISOCountryCode:@"JP" IP:@"1.2.3.4"]; break;
        case 1: [Countly.sharedInstance disableLocationInfo]; break;
        default: break;
    }
}

@end
