// erkanyildiz
// 20160229-1439
//
// https://github.com/erkanyildiz/EYLogViewer
//
// EYLogViewer.m

#import "EYLogViewer.h"

@interface EYLogViewer ()
{
    UIView* vw_container;
    UITextView* txt_console;

    BOOL isBeingDragged;
    BOOL isVisible;
    BOOL canUpdate;
}
@property(nonatomic,strong) NSDate* lastUpdateDate;
@end


@implementation EYLogViewer

const float updateInterval = 0.1;
static EYLogViewer* shared;

+ (void)add
{
    // redirect stderr to log file
    freopen([[EYLogViewer logFilePath] cStringUsingEncoding:NSASCIIStringEncoding], "w", stderr);
    
    shared = EYLogViewer.new;
    [shared tryToFindTopWindow];
}


+ (void)show
{
    [shared showWithAnimation];
}


+ (void)hide
{
    [shared hideWithAnimation];
}


#pragma mark ---


+ (NSString*)logFilePath
{
    static NSString* logFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        NSURL* url = [NSFileManager.defaultManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].lastObject;

        if (![NSFileManager.defaultManager fileExistsAtPath:url.absoluteString])
        {
            NSError* errorDir = nil;
            [NSFileManager.defaultManager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&errorDir];
            if(errorDir){ NSLog(@"Can not create Application Support directory: %@", errorDir); }
        }

        logFilePath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"EYLogViewer.log"];
    });
    
    return logFilePath;
}


#pragma mark ---


-(void)tryToFindTopWindow
{
    UIView* topView = UIApplication.sharedApplication.keyWindow.subviews.lastObject;
    
    if(!topView)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tryToFindTopWindow) object:nil];
        [self performSelector:@selector(tryToFindTopWindow) withObject:nil afterDelay:updateInterval];
    }
    else
    {
        [self setup];
    }
}


-(void)setup
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
    const float consoleHeightRatio = 0.4;   //0.0 to 1.0 from bottom to top
    const float margin = 5;                 //margin in pixels

    CGRect initialRect =(CGRect){
                                    margin,
                                    UIScreen.mainScreen.bounds.size.height * (1.0 - consoleHeightRatio),
                                    UIScreen.mainScreen.bounds.size.width - 2 * margin,
                                    UIScreen.mainScreen.bounds.size.height * consoleHeightRatio - margin
                                };

    vw_container = [UIView.alloc initWithFrame:initialRect];
    vw_container.backgroundColor = [UIColor colorWithRed:156/255.0 green:82/255.0 blue:72/255.0 alpha:1];
    vw_container.alpha = 0.7;
    vw_container.layer.borderWidth = 1;
    vw_container.layer.borderColor =  [UIColor colorWithRed:92/255.0 green:44/255.0 blue:36/255.0 alpha:1].CGColor;
    vw_container.layer.shadowColor = UIColor.blackColor.CGColor;
    vw_container.layer.shadowOffset = (CGSize){0,2};
    vw_container.layer.shadowRadius = 3;
    vw_container.layer.shadowOpacity = 1;
    [UIApplication.sharedApplication.keyWindow addSubview:vw_container];

    // add long press gesture for moving
    UILongPressGestureRecognizer* longPressGestureRec = [UILongPressGestureRecognizer.alloc initWithTarget:self action:@selector(onLongPress:)];
    longPressGestureRec.minimumPressDuration = 0.2;
    [vw_container addGestureRecognizer:longPressGestureRec];
    
    // add double tap press gesture for copying logs
    UITapGestureRecognizer* tapGestureRec = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(onTap:)];
    tapGestureRec.numberOfTapsRequired = 2;
    [vw_container addGestureRecognizer:tapGestureRec];

    // add text view to display logs
    txt_console = [UITextView.alloc initWithFrame:vw_container.bounds];
    txt_console.editable = NO;
    txt_console.selectable = NO;
    txt_console.backgroundColor = UIColor.clearColor;
    txt_console.textColor = [UIColor colorWithRed:215/255.0 green:201/255.0 blue:169/255.0 alpha:1];
    txt_console.font = [UIFont fontWithName:@"Menlo" size:10];
    [vw_container addSubview:txt_console];

    // state bools
    isBeingDragged = NO;
    isVisible = YES;
    canUpdate = YES;
    
    // fire up updater
    NSTimer* timer = [NSTimer timerWithTimeInterval:updateInterval target:self selector:@selector(update) userInfo:nil repeats:YES];
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
}


- (void)update
{
    if(!canUpdate)
        return;

    if(isBeingDragged)
        return;

    // check if log file changed
    NSError* errorAttr = nil;
    NSDictionary* dict = [NSFileManager.defaultManager attributesOfItemAtPath:[EYLogViewer logFilePath] error:&errorAttr];
    if(errorAttr){ NSLog(@"Can not get attributes of log file: %@", errorAttr); }
    if([self.lastUpdateDate isEqualToDate:dict[NSFileModificationDate]])
        return;
    
    // update text view contents with latest logs
    NSError* errorRead = nil;
    NSData* readData = [NSData dataWithContentsOfFile:[EYLogViewer logFilePath] options:0 error:&errorRead];
    if(errorRead){ NSLog(@"Can not read log file: %@", errorRead); }
    NSString* readString = [NSString.alloc initWithData:readData encoding:NSUTF8StringEncoding];

    if(![readString isEqualToString:@""])
        txt_console.text = readString;

    self.lastUpdateDate = dict[NSFileModificationDate];
    
    // deal with uitextview scrolling issues
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(),
    ^{
        UIScrollView* textViewScroll = (UIScrollView*)txt_console;

        BOOL shouldAutoScroll = (textViewScroll.contentOffset.y + txt_console.bounds.size.height*2 >= textViewScroll.contentSize.height);

        if (shouldAutoScroll)
        {
            NSRange myRange = NSMakeRange(txt_console.text.length-1, 0);

            [txt_console scrollRangeToVisible:myRange];
            txt_console.scrollEnabled = NO;
            txt_console.scrollEnabled = YES;
        }
    });
}


#pragma mark ---


- (void)onLongPress:(UIPanGestureRecognizer*)recognizer
{
    // drag drop
    
    UIView* topView = (UIView*)UIApplication.sharedApplication.keyWindow;

    static CGPoint diff;
    static CGPoint scrollContentOffset;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        scrollContentOffset = txt_console.contentOffset;
    
        CGPoint startPoint = [recognizer locationInView:topView];
    
        diff = (CGPoint){vw_container.center.x - startPoint.x, vw_container.center.y - startPoint.y};
    
        isBeingDragged = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = [recognizer locationInView:topView];

        CGPoint adjustedPoint = (CGPoint){currentPoint.x + diff.x, currentPoint.y + diff.y};

        vw_container.center = adjustedPoint;

        txt_console.contentOffset = scrollContentOffset;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        txt_console.contentOffset = scrollContentOffset;

        isBeingDragged = NO;
    }
}


- (void)onTap:(UITapGestureRecognizer*)recognizer
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = txt_console.text;
}


- (void)onSwipeDown:(UISwipeGestureRecognizer*)recognizer
{
    [self hideWithAnimation];
}


- (void)onSwipeUp:(UISwipeGestureRecognizer*)recognizer
{
    [self showWithAnimation];
}


#pragma mark ---


- (void)hideWithAnimation
{
    if(!isVisible)
        return;
    
    isVisible = NO;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
    {
       vw_container.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        canUpdate = NO;
    }];
}


- (void)showWithAnimation
{
    if(isVisible)
        return;
    
    isVisible = YES;
        
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
    {
       vw_container.alpha = 0.7;
    }
    completion:^(BOOL finished)
    {
        canUpdate = YES;
    }];
}

@end
