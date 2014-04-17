//
// main.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.


#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    NSString *logFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"logfile.log"];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"w",stderr);

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
