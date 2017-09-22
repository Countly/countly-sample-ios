// erkanyildiz
// 20170920-1103+0900
//
// EYCrashTesting.m

#import "EYCrashTesting.h"

@implementation EYCrashTesting

+ (void)showInViewController:(UIViewController *)viewController
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Crash Testing" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray* tests =
    @[
        @"Unrecognized Selector",
        @"Out of Bounds",
        @"NULL Pointer",
        @"Invalid Geometry",
        @"Raise Custom Exception",
        @"kill",
        @"__builtin_trap",
        @"Access to a Non-Object",
        @"Message a Released Object",
        @"Write to Read-Only Memory",
        @"Stack Overflow",
        @"abort"
    ];

    for (NSString* title in tests)
    {
        UIAlertAction* action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
        {
            NSUInteger index = [alert.actions indexOfObject:action];

            NSString *selectorName = [NSString stringWithFormat:@"crashTest%lu", (unsigned long)index];

            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if ([self respondsToSelector:NSSelectorFromString(selectorName)])
                    [self performSelector:NSSelectorFromString(selectorName)];
            #pragma clang diagnostic pop
        }];

        [alert addAction:action];
    }

    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];

    [viewController presentViewController:alert animated:YES completion:nil];
}


void aFunction()
{
}


+ (void)crashTest0
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(thisIsTheUnrecognizedSelectorCausingTheCrash)];
    #pragma clang diagnostic pop
}


+ (void)crashTest1
{
    #ifndef __clang_analyzer__
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunused-variable"
    NSArray* anArray = @[@"one",@"two",@"three"];
    NSString* myCrashingString = anArray[5];
    #pragma clang diagnostic pop
    #endif
}


+ (void)crashTest2
{
    #ifndef __clang_analyzer__
    int *nullPointer = NULL;
    *nullPointer = 2017;
    #endif
}


+ (void)crashTest3
{
    CGRect aRect = (CGRect){0.0/0.0, 0.0, 100.0, 100.0};
    UIView *crashView = UIView.new;
    crashView.frame = aRect;
}


+ (void)crashTest4
{
    NSException* e = [NSException exceptionWithName:NSGenericException reason:@"This is the exception!"
                                 userInfo:@{ NSLocalizedDescriptionKey: @"And this is the exception's description."}];
    [e raise];
}


+ (void)crashTest5
{
    kill(getpid(), SIGABRT);
}


+ (void)crashTest6
{
    __builtin_trap();
}


+ (void)crashTest7
{
    NSLog(@"%@", (__bridge NSString *)(void *)100);
}


+ (void)crashTest8
{
    #ifndef __clang_analyzer__
    NSObject*  test = NSObject.new;
    CFRelease((__bridge CFTypeRef)test);
    NSLog(@"%@", test.description);
    #endif
}


+ (void)crashTest9
{
    int *functionPointer = (int*)aFunction;
    *functionPointer = 0;
}


+ (void)crashTest10
{
    [self crashTest10];
}


+ (void)crashTest11
{
    abort();
}

@end
