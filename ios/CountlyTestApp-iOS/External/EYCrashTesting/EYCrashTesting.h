// erkanyildiz
// 20180225-2331+0900
//
// EYCrashTesting.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EYCrashTesting : NSObject

+ (void)showInViewController:(UIViewController *)viewController;

+ (void)crashTest0;     // Unrecognized Selector
+ (void)crashTest1;     // Out of Bounds
+ (void)crashTest2;     // NULL Pointer
+ (void)crashTest3;     // Invalid Geometry
+ (void)crashTest4;     // Raise Custom Exception
+ (void)crashTest5;     // kill
+ (void)crashTest6;     // __builtin_trap
+ (void)crashTest7;     // Access to a Non-Object
+ (void)crashTest8;     // Message a Released Object
+ (void)crashTest9;     // Write to Read-Only Memory
+ (void)crashTest10;    // Stack Overflow
+ (void)crashTest11;    // abort

@end
