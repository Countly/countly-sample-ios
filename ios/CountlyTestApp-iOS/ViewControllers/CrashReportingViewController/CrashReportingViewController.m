// CrashReportingViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "CrashReportingViewController.h"
#import "EYCrashTesting.h"
#import "Countly.h"

@implementation CrashReportingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Crash Reporting";

    self.tests = @[
        @{@"name": @"Unrecognized Selector", @"explanation": @"thisIsTheUnrecognizedSelectorCausingTheCrash"},
        @{@"name": @"Out of Bounds", @"explanation": @"5th element in a 3 elements array"},
        @{@"name": @"NULL Pointer", @"explanation": @"Dereference"},
        @{@"name": @"Invalid Geometry", @"explanation": @"CALayer position contains nan"},
        @{@"name": @"Raise Custom Exception", @"explanation": @"This is the exception!"},
        @{@"name": @"kill", @"explanation": @"with SIGABRT"},
        @{@"name": @"__builtin_trap", @"explanation": @""},
        @{@"name": @"Access to a Non-Object", @"explanation": @""},
        @{@"name": @"Message a Released Object", @"explanation": @""},
        @{@"name": @"Write to Read-Only Memory", @"explanation": @"using function pointer aFunction"},
        @{@"name": @"Stack Overflow", @"explanation": @"infinite recursive call"},
        @{@"name": @"abort", @"explanation": @""},
        @{@"name": @"Custom Crash Log", @"explanation": @"This is a custom crash log!"},
        @{@"name": @"Record Handled Exception", @"explanation": @"n:MyException  r:MyReason  d:{key:value}"},
        @{@"name": @"Record Handled Exception with Stack Trace", @"explanation": @"n:MyExc  r:MyReason  d:{key:value} and stack trace"},
        @{@"name": @"Record Unhandled Exception with Stack Trace", @"explanation": @"n:MyUnhandledExc  r:MyReason  d:{key:value} and stack trace"},
        @{@"name": @"Record Error with Stack Trace", @"explanation": @"errorName:SwiftStyleError"},
        @{@"name": @"Record Fatal Error with Segmentation", @"explanation": @"errorName:FatalSwiftError isFatal:YES"},
        @{@"name": @"Clear Crash Logs", @"explanation": @""},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
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

        case 12: [Countly.sharedInstance recordCrashLog:@"This is a custom crash log!"]; break;

        case 13:
        {
            NSException *myException = [NSException exceptionWithName:@"MyException" reason:@"MyReason" userInfo:@{@"key": @"value"}];
            [Countly.sharedInstance recordException:myException];
        } break;

        case 14:
        {
            NSException *myException = [NSException exceptionWithName:@"MyExc" reason:@"MyReason" userInfo:@{@"key": @"value"}];
            [Countly.sharedInstance recordException:myException isFatal:NO stackTrace:[NSThread callStackSymbols] segmentation:nil];
        } break;

        case 15:
        {
            NSException *myException = [NSException exceptionWithName:@"MyUnhandledExc" reason:@"MyReason" userInfo:@{@"key": @"value"}];
            [Countly.sharedInstance recordException:myException isFatal:YES stackTrace:[NSThread callStackSymbols] segmentation:nil];
        } break;

        case 16:
        {
            [Countly.sharedInstance recordError:@"SwiftStyleError" stackTrace:[NSThread callStackSymbols]];
        } break;

        case 17:
        {
            [Countly.sharedInstance recordError:@"FatalSwiftError" isFatal:YES stackTrace:[NSThread callStackSymbols] segmentation:@{@"module": @"test"}];
        } break;

        case 18: [Countly.sharedInstance clearCrashLogs]; break;

        default: break;
    }
}

@end
