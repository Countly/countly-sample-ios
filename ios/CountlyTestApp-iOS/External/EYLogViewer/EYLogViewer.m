// erkanyildiz
// 20180107-2246+0900
//
// https://github.com/erkanyildiz/EYLogViewer
//
// EYLogViewer.m

#import "EYLogViewer.h"
#import <UIKit/UIKit.h>
#include <pthread.h>


@interface EYLogViewer ()
{
    UIView* vw_container;
    UITextView* tx_console;

    BOOL isBeingDragged;
    BOOL isVisible;
}
@end


@implementation EYLogViewer

+ (instancetype)sharedInstance
{
    static EYLogViewer* s_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ s_sharedInstance = self.new; });
    return s_sharedInstance;
}

+ (void)add
{
    NSPipe* pipe = NSPipe.pipe;
    NSFileHandle* fhr = pipe.fileHandleForReading;
    dup2(pipe.fileHandleForWriting.fileDescriptor, fileno(stderr));
    dup2(pipe.fileHandleForWriting.fileDescriptor, fileno(stdout));
    [NSNotificationCenter.defaultCenter addObserver:EYLogViewer.sharedInstance selector:@selector(readCompleted:) name:NSFileHandleReadCompletionNotification object:fhr];
    [fhr readInBackgroundAndNotify];

    [EYLogViewer.sharedInstance tryToFindTopWindow];
}


+ (void)show
{
    [EYLogViewer.sharedInstance showWithAnimation];
}


+ (void)hide
{
    [EYLogViewer.sharedInstance hideWithAnimation];
}


+ (void)clear
{
    [EYLogViewer.sharedInstance clearConsole];
}


#pragma mark -


- (void)tryToFindTopWindow
{
    if (!UIApplication.sharedApplication.keyWindow.subviews.lastObject)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tryToFindTopWindow) object:nil];
        [self performSelector:@selector(tryToFindTopWindow) withObject:nil afterDelay:0.1];
    }
    else
    {
        [self setup];
    }
}


- (void)setup
{
    // add three finger swipe down gesture for hiding
    UISwipeGestureRecognizer* swipeDownGestureRec = [UISwipeGestureRecognizer.alloc initWithTarget:self action:@selector(onSwipeDown:)];
    swipeDownGestureRec.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDownGestureRec.numberOfTouchesRequired = 3;
    [UIApplication.sharedApplication.keyWindow addGestureRecognizer:swipeDownGestureRec];

    // add three finger swipe up gesture for showing
    UISwipeGestureRecognizer* swipeUpGestureRec = [UISwipeGestureRecognizer.alloc initWithTarget:self action:@selector(onSwipeUp:)];
    swipeUpGestureRec.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUpGestureRec.numberOfTouchesRequired = 3;
    [UIApplication.sharedApplication.keyWindow addGestureRecognizer:swipeUpGestureRec];

    // add container view with border, shadow, background color etc...
    CGFloat const consoleHeightRatio = 0.4;   // 0.0 to 1.0 from bottom to top
    CGFloat const margin = 5.0;               // margin in pixels
    CGRect initialRect = (CGRect)
    {
        margin,
        UIScreen.mainScreen.bounds.size.height * (1.0 - consoleHeightRatio),
        UIScreen.mainScreen.bounds.size.width - 2.0 * margin,
        UIScreen.mainScreen.bounds.size.height * consoleHeightRatio - margin
    };
    vw_container = [UIView.alloc initWithFrame:initialRect];
    vw_container.backgroundColor = [UIColor colorWithRed:156/255.0 green:82/255.0 blue:72/255.0 alpha:1];
    vw_container.alpha = 0.85;
    vw_container.layer.borderWidth = 1.0;
    vw_container.layer.borderColor = [UIColor colorWithRed:92/255.0 green:44/255.0 blue:36/255.0 alpha:1].CGColor;
    vw_container.layer.shadowColor = UIColor.blackColor.CGColor;
    vw_container.layer.shadowOffset = (CGSize){0.0, 2.0};
    vw_container.layer.shadowRadius = 3.0;
    vw_container.layer.shadowOpacity = 1.0;
    [UIApplication.sharedApplication.keyWindow addSubview:vw_container];

    // add long press gesture for moving
    UILongPressGestureRecognizer* longPressGestureRec = [UILongPressGestureRecognizer.alloc initWithTarget:self action:@selector(onLongPress:)];
    longPressGestureRec.minimumPressDuration = 0.2;
    [vw_container addGestureRecognizer:longPressGestureRec];

    // add double tap press gesture for copying logs
    UITapGestureRecognizer* doubleTapGestureRec = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(onDoubleTap:)];
    doubleTapGestureRec.numberOfTapsRequired = 2;
    [vw_container addGestureRecognizer:doubleTapGestureRec];

    // add triple tap press gesture for clearing logs
    UITapGestureRecognizer* tripleTapGestureRec = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(onTripleTap:)];
    tripleTapGestureRec.numberOfTapsRequired = 3;
    [vw_container addGestureRecognizer:tripleTapGestureRec];

    // add text view to display logs
    tx_console = [UITextView.alloc initWithFrame:vw_container.bounds];
    tx_console.editable = NO;
    tx_console.selectable = NO;
    tx_console.backgroundColor = UIColor.clearColor;
    tx_console.textColor = [UIColor colorWithRed:215/255.0 green:201/255.0 blue:169/255.0 alpha:1];
    tx_console.font = [UIFont fontWithName:@"Menlo" size:10.0];
    [vw_container addSubview:tx_console];

    // state bools
    isBeingDragged = NO;
    isVisible = YES;
}


- (void)readCompleted:(NSNotification*)notification
{
    [((NSFileHandle*)notification.object) readInBackgroundAndNotify];
    NSString* logs = [NSString.alloc initWithData:notification.userInfo[NSFileHandleNotificationDataItem] encoding:NSUTF8StringEncoding];

    dispatch_async(dispatch_get_main_queue(), ^
    {
        tx_console.text = [tx_console.text stringByAppendingFormat:@"%@",logs];
    });

    if (isBeingDragged)
        return;

    // deal with uitextview scrolling issues
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        BOOL shouldAutoScroll = (tx_console.contentOffset.y + tx_console.bounds.size.height * 2 >= tx_console.contentSize.height);
        if (shouldAutoScroll)
        {
            [tx_console scrollRangeToVisible:(NSRange){tx_console.text.length - 1, 0}];
            tx_console.scrollEnabled = NO;
            tx_console.scrollEnabled = YES;
        }
    });
}


#pragma mark -


- (void)onLongPress:(UIPanGestureRecognizer*)recognizer
{
    // drag drop
    UIView* topView = (UIView*)UIApplication.sharedApplication.keyWindow;
    static CGPoint diff;
    static CGPoint scrollContentOffset;

    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        scrollContentOffset = tx_console.contentOffset;
        CGPoint startPoint = [recognizer locationInView:topView];
        diff = (CGPoint){vw_container.center.x - startPoint.x, vw_container.center.y - startPoint.y};
        isBeingDragged = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = [recognizer locationInView:topView];
        CGPoint adjustedPoint = (CGPoint){currentPoint.x + diff.x, currentPoint.y + diff.y};
        vw_container.center = adjustedPoint;
        tx_console.contentOffset = scrollContentOffset;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        tx_console.contentOffset = scrollContentOffset;
        isBeingDragged = NO;
    }
}


- (void)onDoubleTap:(UITapGestureRecognizer*)recognizer
{
    UIPasteboard.generalPasteboard.string = tx_console.text;
}


- (void)onTripleTap:(UITapGestureRecognizer*)recognizer
{
    [self clearConsole];
}


- (void)onSwipeDown:(UISwipeGestureRecognizer*)recognizer
{
    [self hideWithAnimation];
}


- (void)onSwipeUp:(UISwipeGestureRecognizer*)recognizer
{
    [self showWithAnimation];
}


#pragma mark -


- (void)hideWithAnimation
{
    if (!isVisible)
        return;

    isVisible = NO;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ vw_container.alpha = 0.0; } completion:nil];
}


- (void)showWithAnimation
{
    if (isVisible)
        return;

    isVisible = YES;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ vw_container.alpha = 0.7; }completion:nil];
}


- (void)clearConsole
{
    tx_console.text = @"";
}

@end
