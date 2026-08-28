// CountlyScenarios.m
//
// Manual test driver for the Objective-C SDK, used as the baseline the Swift SDK
// is compared against.
//
// One scenario per launch, selected with -CountlyScenario <name>. The Swift host
// application has a twin of this file; the two must stay in step or the comparison
// means nothing. See Tools/parity/SCENARIOS.md in countly-sdk-swift.

#import "AppDelegate.h"
#import "Countly.h"
#import <CoreLocation/CoreLocation.h>

NSString* CountlyScenarioName(void)
{
    NSString* name = [NSUserDefaults.standardUserDefaults stringForKey:@"CountlyScenario"];
    return name.length ? name : @"init-basic";
}

// Applies the init-time configuration a scenario needs. Several scenarios are
// about a config flag rather than a call, so the setup is part of the scenario.
// Resets the configuration to what both sample applications agree on.
//
// The two applications are demos first and are configured differently on purpose:
// one enables push and automatic remote config triggers, the other does not. Those
// differences reach the wire and would be read as SDK divergences. A scenario run
// therefore starts from a fixed baseline and the scenario's own overrides go on
// top of it.
static void ApplyParityBaseline(CountlyConfig* config)
{
    config.appKey = @"parity_app_key";
    config.host = @"http://localhost:8080";
    config.deviceID = @"parity-device";
    config.enableDebug = YES;
    config.internalLogLevel = CLYInternalLogLevelDebug;
    config.features = @[CLYCrashReporting];
    config.updateSessionPeriod = 60;
    config.requiresConsent = NO;
    config.enableRemoteConfigAutomaticTriggers = NO;
    // The deprecated flag still triggers an automatic download on its own, and the
    // Swift SDK has no equivalent because the deprecated surface was not ported.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    config.enableRemoteConfig = NO;
#pragma clang diagnostic pop
    config.enableRemoteConfigValueCaching = NO;
    config.enableAutomaticViewTracking = NO;
    config.alwaysUsePOST = NO;
}

void CountlyScenarioConfigure(CountlyConfig* config, NSString* scenario)
{
    ApplyParityBaseline(config);

    if ([scenario isEqualToString:@"init-no-consent"] ||
        [scenario hasPrefix:@"consent-"])
    {
        config.requiresConsent = YES;
    }

    if ([scenario isEqualToString:@"session-manual"])
    {
        config.manualSessionHandling = YES;
    }

    if ([scenario isEqualToString:@"session-manual-hybrid"])
    {
        config.manualSessionHandling = YES;
        config.enableManualSessionControlHybridMode = YES;
    }

    if ([scenario isEqualToString:@"event-threshold"])
    {
        config.eventSendThreshold = 3;
    }

    if ([scenario isEqualToString:@"event-limits"])
    {
        [config.sdkInternalLimits setMaxKeyLength:8];
        [config.sdkInternalLimits setMaxValueSize:10];
        [config.sdkInternalLimits setMaxSegmentationValues:3];
    }

    if ([scenario isEqualToString:@"view-segmentation"])
    {
        config.globalViewSegmentation = @{@"from_config": @"yes"};
    }

    if ([scenario isEqualToString:@"deviceid-temporary"])
    {
        config.deviceID = CLYTemporaryDeviceID;
    }

    if ([scenario isEqualToString:@"crash-segmentation"])
    {
        config.crashSegmentation = @{@"global_crash": @"from_config"};
    }

    if ([scenario hasPrefix:@"rc-"])
    {
        config.enableRemoteConfigAutomaticTriggers = YES;
        config.enableRemoteConfigValueCaching = YES;
    }

    if ([scenario isEqualToString:@"rc-ab"])
    {
        config.enrollABOnRCDownload = YES;
    }

    if ([scenario isEqualToString:@"location"])
    {
        config.location = (CLLocationCoordinate2D){38.4237, 27.1428};
        config.city = @"Izmir";
        config.ISOCountryCode = @"TR";
        config.IP = @"10.0.0.1";
    }

    if ([scenario isEqualToString:@"attribution"])
    {
        config.campaignType = @"countly";
        config.campaignData = @"{\"cid\":\"config_campaign\",\"cuid\":\"config_user\"}";
    }

    if ([scenario isEqualToString:@"salt"])
    {
        config.secretSalt = @"parity_salt";
    }

    if ([scenario isEqualToString:@"migration-seed-cache"])
    {
        // Against the live rich server, so remote config values and behavior
        // settings are downloaded and written to the cache the next SDK has to
        // read. The device ID is left unset so a generated one is stored too.
        config.deviceID = nil;
        config.enableRemoteConfigAutomaticTriggers = YES;
        config.enableRemoteConfigValueCaching = YES;
    }

    if ([scenario isEqualToString:@"migration-seed"])
    {
        // A port nothing is listening on, so every request fails and stays in the
        // queue on disk. The device ID is left unset so the SDK generates and
        // stores one, which is the thing a migration most has to preserve.
        config.host = @"http://localhost:9";
        config.deviceID = nil;
    }

    if ([scenario hasPrefix:@"view-auto"] || [scenario isEqualToString:@"lifecycle-views-background"])
    {
        config.enableAutomaticViewTracking = YES;

        // The host's own root screen is excluded so the capture contains only the
        // controllers the scenario presents. The two host applications have
        // different root screens, and that is a property of the hosts, not of the
        // SDKs. `view-auto-exclusion` is what actually tests the mechanism.
        NSMutableArray* exclusions = [@[@"Countly", @"MainViewController"] mutableCopy];
        if ([scenario isEqualToString:@"view-auto-exclusion"])
            [exclusions addObject:@"AutoViewExcluded"];
        config.automaticViewTrackingExclusionList = exclusions;
    }

    if ([scenario hasPrefix:@"session-auto"] || [scenario hasPrefix:@"lifecycle-"])
    {
        // Short enough that the update timer fires inside the capture window.
        config.updateSessionPeriod = 5;
    }
}

#pragma mark - View controller helpers

// Presents a plain view controller with a known title. Automatic view tracking
// names a view after its title before falling back to the class name, so a title
// is what makes the two host applications comparable: `NSStringFromClass` would
// give a bare name here and a module qualified one in Swift.
static void PresentTitled(NSString* title)
{
    UIViewController* vc = UIViewController.new;
    vc.title = title;
    vc.view.backgroundColor = UIColor.systemBackgroundColor;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;

    UIViewController* top = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (top.presentedViewController)
        top = top.presentedViewController;

    [top presentViewController:vc animated:NO completion:nil];
}

static void DismissTop(void)
{
    UIViewController* top = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (top.presentedViewController)
        top = top.presentedViewController;

    [top dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Step runner

static void RunSteps(NSArray<dispatch_block_t>* steps, NSUInteger index, NSTimeInterval gap)
{
    if (index >= steps.count)
    {
        NSLog(@"[SCENARIO] done, stepCount: %lu", (unsigned long)steps.count);
        return;
    }

    NSLog(@"[SCENARIO] step %lu/%lu", (unsigned long)(index + 1), (unsigned long)steps.count);
    steps[index]();

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(gap * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RunSteps(steps, index + 1, gap);
    });
}

#pragma mark - Scenarios

static NSArray<dispatch_block_t>* StepsForScenario(NSString* scenario)
{
    Countly* cly = Countly.sharedInstance;
    __block NSString* viewID = nil;

    // --- lifecycle --------------------------------------------------------

    if ([scenario isEqualToString:@"init-basic"])
        return @[
            ^{ NSLog(@"[SCENARIO] nothing beyond init"); },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"init-no-consent"])
        return @[
            ^{ [cly recordEvent:@"should_not_be_recorded"]; },
            ^{ [cly.views startView:@"ShouldNotBeRecorded" segmentation:nil]; },
            ^{ [cly.userProfile setProperty:@"name" value:@"nobody"]; [cly.userProfile save]; },
            ^{ [cly recordError:@"ShouldNotBeRecorded" stackTrace:nil]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"consent-give-all"])
        return @[
            ^{ [cly giveAllConsents]; },
            ^{ [cly recordEvent:@"after_all_consents"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"consent-give-individual"])
        return @[
            ^{ [cly giveConsentForFeature:CLYConsentSessions]; },
            ^{ [cly giveConsentForFeature:CLYConsentEvents]; },
            ^{ [cly recordEvent:@"after_event_consent"]; },
            ^{ [cly giveConsentForFeature:CLYConsentViewTracking]; },
            ^{ [cly.views startView:@"AfterViewConsent" segmentation:nil]; },
            ^{ [cly giveConsentForFeatures:@[CLYConsentUserDetails, CLYConsentLocation]]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"consent-remove-individual"])
        return @[
            ^{ [cly giveAllConsents]; },
            ^{ [cly recordEvent:@"while_consented"]; },
            ^{ [cly cancelConsentForFeature:CLYConsentEvents]; },
            ^{ [cly recordEvent:@"after_events_cancelled"]; },
            ^{ [cly cancelConsentForFeature:CLYConsentLocation]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"consent-remove-all"])
        return @[
            ^{ [cly giveAllConsents]; },
            ^{ [cly recordEvent:@"while_consented"]; },
            ^{ [cly cancelConsentForAllFeatures]; },
            ^{ [cly recordEvent:@"after_all_cancelled"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"session-manual"])
        return @[
            ^{ [cly beginSession]; },
            ^{ [cly recordEvent:@"during_manual_session"]; },
            ^{ [cly updateSession]; },
            ^{ [cly endSession]; },
            ^{ [cly recordEvent:@"after_manual_session"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"session-manual-hybrid"])
        return @[
            ^{ [cly beginSession]; },
            ^{ [cly recordEvent:@"during_hybrid_session"]; },
            ^{ [cly updateSession]; },
            ^{ [cly endSession]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"session-auto-inert"])
        return @[
            ^{ [cly beginSession]; },
            ^{ [cly updateSession]; },
            ^{ [cly endSession]; },
            ^{ [cly recordEvent:@"after_ignored_session_calls"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- events -----------------------------------------------------------

    if ([scenario isEqualToString:@"event-basic"])
        return @[
            ^{ [cly recordEvent:@"evt_plain"]; },
            ^{ [cly recordEvent:@"evt_count" count:3]; },
            ^{ [cly recordEvent:@"evt_sum" sum:12.5]; },
            ^{ [cly recordEvent:@"evt_duration" duration:4]; },
            ^{ [cly recordEvent:@"evt_count_sum" count:2 sum:7.25]; },
            ^{ [cly recordEvent:@"evt_seg" segmentation:@{@"colour": @"red", @"size": @42, @"flag": @YES}]; },
            ^{ [cly recordEvent:@"evt_full" segmentation:@{@"a": @"b"} count:5 sum:1.5 duration:2]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"event-timed"])
        return @[
            ^{ [cly startEvent:@"evt_timed"]; },
            ^{ [cly endEvent:@"evt_timed" segmentation:@{@"outcome": @"ok"} count:1 sum:0]; },
            ^{ [cly startEvent:@"evt_cancelled"]; },
            ^{ [cly cancelEvent:@"evt_cancelled"]; },
            ^{ [cly endEvent:@"evt_never_started"]; },
            ^{ [cly startEvent:@"evt_started_twice"]; },
            ^{ [cly startEvent:@"evt_started_twice"]; },
            ^{ [cly endEvent:@"evt_started_twice"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"event-threshold"])
        return @[
            ^{ [cly recordEvent:@"threshold_one"]; },
            ^{ [cly recordEvent:@"threshold_two"]; },
            ^{ [cly recordEvent:@"threshold_three"]; },
            ^{ [cly recordEvent:@"threshold_four"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"event-limits"])
        return @[
            ^{ [cly recordEvent:@"a_very_long_event_key_indeed"]; },
            ^{ [cly recordEvent:@"lim_seg" segmentation:@{@"a_very_long_segmentation_key": @"a_very_long_segmentation_value"}]; },
            ^{ [cly recordEvent:@"lim_count" segmentation:@{@"k1": @"v1", @"k2": @"v2", @"k3": @"v3", @"k4": @"v4", @"k5": @"v5"}]; },
            ^{ [cly recordEvent:@"" segmentation:@{@"dropped": @"yes"}]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- views ------------------------------------------------------------

    if ([scenario isEqualToString:@"view-manual"])
        return @[
            ^{ viewID = [cly.views startView:@"HomeView" segmentation:@{@"origin": @"launch"}]; },
            ^{ [cly.views stopViewWithName:@"HomeView" segmentation:@{@"reason": @"navigated"}]; },
            ^{ viewID = [cly.views startView:@"ByIdView" segmentation:nil]; },
            ^{ [cly.views stopViewWithID:viewID segmentation:nil]; },
            ^{ [cly.views startAutoStoppedView:@"AutoStoppedA" segmentation:nil]; },
            ^{ [cly.views startAutoStoppedView:@"AutoStoppedB" segmentation:nil]; },
            ^{ [cly.views stopViewWithName:@"MissingView" segmentation:nil]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"view-pause-resume"])
        return @[
            ^{ viewID = [cly.views startView:@"PausableView" segmentation:nil]; },
            ^{ [cly.views pauseViewWithID:viewID]; },
            ^{ [cly.views resumeViewWithID:viewID]; },
            ^{ [cly.views stopViewWithID:viewID segmentation:nil]; },
            ^{ [cly.views startView:@"LeftOpenOne" segmentation:nil]; },
            ^{ [cly.views startView:@"LeftOpenTwo" segmentation:nil]; },
            ^{ [cly.views stopAllViews:@{@"bulk": @"yes"}]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"view-segmentation"])
        return @[
            ^{ [cly.views startView:@"WithConfigSegmentation" segmentation:nil]; },
            ^{ [cly.views setGlobalViewSegmentation:@{@"tier": @"gold"}]; },
            ^{ [cly.views startView:@"WithGlobalSegmentation" segmentation:@{@"local": @"yes"}]; },
            ^{ [cly.views updateGlobalViewSegmentation:@{@"tier": @"platinum", @"extra": @"added"}]; },
            ^{ [cly.views addSegmentationToViewWithName:@"WithGlobalSegmentation" segmentation:@{@"late": @"addition"}]; },
            ^{ [cly.views stopAllViews:nil]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- user profile -----------------------------------------------------

    if ([scenario isEqualToString:@"userprofile-predefined"])
        return @[
            ^{ [cly.userProfile setProperty:@"name" value:@"Parity Tester"]; },
            ^{ [cly.userProfile setProperties:@{@"email": @"parity@example.com", @"username": @"parity", @"organization": @"Countly", @"phone": @"+10000000000", @"gender": @"M", @"byear": @1990}]; },
            ^{ [cly.userProfile save]; },
            ^{ [cly.userProfile setProperty:@"name" value:@""]; },
            ^{ [cly.userProfile save]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"userprofile-custom"])
        return @[
            ^{ [cly.userProfile setProperties:@{@"custom_string": @"value", @"custom_number": @11, @"custom_bool": @YES}]; },
            ^{ [cly.userProfile setProperty:@"custom_cleared" value:@"to_be_cleared"]; },
            ^{ [cly.userProfile setProperty:@"custom_cleared" value:@""]; },
            ^{ [cly.userProfile setProperties:@{@"unsupported_type": [NSDate dateWithTimeIntervalSince1970:0]}]; },
            ^{ [cly.userProfile save]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"userprofile-modifiers"])
        return @[
            ^{ [cly.userProfile setOnce:@"once_key" value:@"first"]; },
            ^{ [cly.userProfile setOnce:@"once_key" value:@"second"]; },
            ^{ [cly.userProfile increment:@"visits"]; },
            ^{ [cly.userProfile incrementBy:@"score" value:@25]; },
            ^{ [cly.userProfile multiply:@"score" value:@2]; },
            ^{ [cly.userProfile max:@"highscore" value:@99]; },
            ^{ [cly.userProfile min:@"lowscore" value:@1]; },
            ^{ [cly.userProfile push:@"tags" value:@"alpha"]; },
            ^{ [cly.userProfile push:@"tags" value:@"beta"]; },
            ^{ [cly.userProfile pushUnique:@"unique_tags" value:@"gamma"]; },
            ^{ [cly.userProfile pull:@"tags" value:@"alpha"]; },
            ^{ [cly.userProfile save]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- device id --------------------------------------------------------

    if ([scenario isEqualToString:@"deviceid-merge"])
        return @[
            ^{ [cly recordEvent:@"before_merge"]; },
            ^{ [cly changeDeviceIDWithMerge:@"parity-device-merged"]; },
            ^{ [cly recordEvent:@"after_merge"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"deviceid-no-merge"])
        return @[
            ^{ [cly recordEvent:@"before_no_merge"]; },
            ^{ [cly changeDeviceIDWithoutMerge:@"parity-device-fresh"]; },
            ^{ [cly recordEvent:@"after_no_merge"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"deviceid-temporary"])
        return @[
            ^{ [cly recordEvent:@"while_temporary"]; },
            ^{ [cly.views startView:@"TemporaryView" segmentation:nil]; },
            ^{ [cly attemptToSendStoredRequests]; },
            ^{ [cly changeDeviceIDWithoutMerge:@"parity-device-real"]; },
            ^{ [cly recordEvent:@"after_real_id"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- crashes ----------------------------------------------------------

    if ([scenario isEqualToString:@"crash-handled"])
        return @[
            ^{ [cly recordError:@"ParityHandledError" stackTrace:@[@"frame one", @"frame two"]]; },
            ^{ [cly recordException:[NSException exceptionWithName:@"ParityException" reason:@"parity reason" userInfo:@{@"info": @"value"}] isFatal:NO stackTrace:@[@"frame three"] segmentation:nil]; },
            ^{ [cly recordError:@"ParityFatalError" isFatal:YES stackTrace:@[@"fatal frame"] segmentation:nil]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"crash-breadcrumbs"])
        return @[
            ^{ [cly recordCrashLog:@"breadcrumb one"]; },
            ^{ [cly recordCrashLog:@"breadcrumb two"]; },
            ^{ [cly recordCrashLog:@"breadcrumb three"]; },
            ^{ [cly recordError:@"WithBreadcrumbs" stackTrace:nil]; },
            ^{ [cly clearCrashLogs]; },
            ^{ [cly recordError:@"WithoutBreadcrumbs" stackTrace:nil]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"crash-segmentation"])
        return @[
            ^{ [cly recordError:@"GlobalSegmentationOnly" stackTrace:nil]; },
            // The Objective-C SDK has no runtime setter for this; only the init
            // config carries it. The Swift SDK adds one, which this step cannot
            // exercise on the baseline side.
            ^{ NSLog(@"[SCENARIO] no runtime crash segmentation setter on this SDK"); },
            ^{ [cly recordException:[NSException exceptionWithName:@"MergedSegmentation" reason:@"reason" userInfo:nil] isFatal:NO stackTrace:nil segmentation:@{@"per_call": @"override"}]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- remote config ----------------------------------------------------

    if ([scenario isEqualToString:@"rc-download"])
        return @[
            ^{ [cly.remoteConfig downloadKeys:^(CLYRequestResult response, NSError* error, BOOL full, NSDictionary* values) {
                NSLog(@"[SCENARIO] downloadKeys result: %@, full: %d, count: %lu", response, full, (unsigned long)values.count); }]; },
            ^{ NSLog(@"[SCENARIO] getValue welcome_text: %@", [cly.remoteConfig getValue:@"welcome_text"].value); },
            ^{ NSLog(@"[SCENARIO] getValue missing_key: %@", [cly.remoteConfig getValue:@"missing_key"].value); },
            ^{ NSLog(@"[SCENARIO] getAllValues count: %lu", (unsigned long)[cly.remoteConfig getAllValues].count); },
            ^{ [cly.remoteConfig downloadSpecificKeys:@[@"welcome_text"] completionHandler:nil]; },
            ^{ [cly.remoteConfig downloadOmittingKeys:@[@"flag"] completionHandler:nil]; },
            ^{ [cly.remoteConfig clearAll]; },
            ^{ NSLog(@"[SCENARIO] after clearAll count: %lu", (unsigned long)[cly.remoteConfig getAllValues].count); },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"rc-ab"])
        return @[
            ^{ [cly.remoteConfig downloadKeys:nil]; },
            ^{ [cly.remoteConfig testingDownloadVariantInformation:^(CLYRequestResult response, NSError* error) {
                NSLog(@"[SCENARIO] variants: %@", [cly.remoteConfig testingGetAllVariants]); }]; },
            ^{ [cly.remoteConfig testingDownloadExperimentInformation:^(CLYRequestResult response, NSError* error) {
                NSLog(@"[SCENARIO] experiments: %lu", (unsigned long)[cly.remoteConfig testingGetAllExperimentInfo].count); }]; },
            ^{ [cly.remoteConfig enrollIntoABTestsForKeys:@[@"welcome_text"]]; },
            ^{ [cly.remoteConfig exitABTestsForKeys:@[@"welcome_text"]]; },
            ^{ NSLog(@"[SCENARIO] getValueAndEnroll: %@", [cly.remoteConfig getValueAndEnroll:@"welcome_text"].value); },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- feedback ---------------------------------------------------------

    if ([scenario isEqualToString:@"feedback-list"])
        return @[
            ^{ [cly.feedback getAvailableFeedbackWidgets:^(NSArray* widgets, NSError* error) {
                NSLog(@"[SCENARIO] widgets: %lu, error: %@", (unsigned long)widgets.count, error); }]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"feedback-record"])
        return @[
            ^{ [cly recordRatingWidgetWithID:@"widget_rating_1" rating:4 email:@"parity@example.com" comment:@"good" userCanBeContacted:YES]; },
            ^{ [cly recordRatingWidgetWithID:@"widget_rating_2" rating:1 email:nil comment:nil userCanBeContacted:NO]; },
            ^{ [cly recordRatingWidgetWithID:@"" rating:3 email:nil comment:nil userCanBeContacted:NO]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- everything else --------------------------------------------------

    if ([scenario isEqualToString:@"attribution"])
        return @[
            ^{ [cly recordDirectAttributionWithCampaignType:@"countly" andCampaignData:@"{\"cid\":\"campaign1\",\"cuid\":\"user1\"}"]; },
            ^{ [cly recordDirectAttributionWithCampaignType:@"countly" andCampaignData:@"{\"cid\":\"campaign_no_user\"}"]; },
            ^{ [cly recordDirectAttributionWithCampaignType:@"unsupported" andCampaignData:@"{\"cid\":\"nope\"}"]; },
            ^{ [cly recordIndirectAttribution:@{@"idfa": @"PARITY-IDFA"}]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"apm"])
        return @[
            ^{ [cly recordNetworkTrace:@"parity_network" requestPayloadSize:128 responsePayloadSize:256 responseStatusCode:200 startTime:1700000000000 endTime:1700000000500]; },
            ^{ [cly startCustomTrace:@"parity_trace"]; },
            ^{ [cly endCustomTrace:@"parity_trace" metrics:@{@"steps": @3}]; },
            ^{ [cly startCustomTrace:@"parity_cancelled"]; },
            ^{ [cly cancelCustomTrace:@"parity_cancelled"]; },
            ^{ [cly endCustomTrace:@"parity_never_started" metrics:nil]; },
            ^{ [cly appLoadingFinished]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"location"])
        return @[
            ^{ [cly recordLocation:(CLLocationCoordinate2D){40.7128, -74.0060} city:@"New York" ISOCountryCode:@"US" IP:@"10.0.0.2"]; },
            ^{ [cly disableLocationInfo]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"queue-ops"])
        return @[
            ^{ [cly recordEvent:@"queued_one"]; },
            ^{ [cly recordEvent:@"queued_two"]; },
            ^{ [cly flushQueues]; },
            ^{ [cly recordEvent:@"after_flush"]; },
            ^{ [cly replaceAllAppKeysInQueueWithCurrentAppKey]; },
            ^{ [cly removeDifferentAppKeysFromQueue]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"direct-request"])
        return @[
            ^{ [cly recordMetrics:@{@"_custom_metric": @"custom_value"}]; },
            ^{ [cly addDirectRequest:@{@"custom_key": @"custom_value", @"device_id": @"should_be_stripped"}]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"sbs-restrictive"])
        return @[
            ^{ [cly recordEvent:@"under_restrictive_settings"]; },
            ^{ [cly.views startView:@"UnderRestrictiveSettings" segmentation:nil]; },
            ^{ [cly recordError:@"UnderRestrictiveSettings" stackTrace:nil]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"salt"])
        return @[
            ^{ [cly recordEvent:@"salted_event"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- automatic view tracking ------------------------------------------

    if ([scenario isEqualToString:@"view-auto"])
        return @[
            ^{ PresentTitled(@"AutoViewOne"); },
            ^{ PresentTitled(@"AutoViewTwo"); },
            ^{ DismissTop(); },
            ^{ DismissTop(); },
            ^{ PresentTitled(@"AutoViewThree"); },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"view-auto-exclusion"])
        return @[
            ^{ PresentTitled(@"AutoViewExcluded"); },
            ^{ PresentTitled(@"AutoViewIncluded"); },
            ^{ DismissTop(); },
            ^{ DismissTop(); },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    // --- automatic sessions -------------------------------------------------

    if ([scenario isEqualToString:@"session-auto-update"])
        return @[
            ^{ [cly recordEvent:@"before_first_tick"]; },
            ^{ NSLog(@"[SCENARIO] waiting for the session update timer"); },
            ^{ NSLog(@"[SCENARIO] still waiting"); },
            ^{ NSLog(@"[SCENARIO] still waiting"); },
        ];

    if ([scenario isEqualToString:@"session-auto-background"])
        return @[
            ^{ [cly recordEvent:@"before_background"]; },
            ^{ NSLog(@"[SCENARIO] waiting for the harness to background the app"); },
        ];

    // --- foreground and background ------------------------------------------

    if ([scenario isEqualToString:@"lifecycle-background"])
        return @[
            ^{ [cly recordEvent:@"before_background"]; },
            ^{ [cly.userProfile setProperty:@"name" value:@"Before Background"]; },
            ^{ NSLog(@"[SCENARIO] waiting for the harness to background the app"); },
        ];

    if ([scenario isEqualToString:@"lifecycle-events-background"])
        return @[
            ^{ [cly recordEvent:@"before_background"]; },
            ^{ NSLog(@"[SCENARIO] waiting for the harness to background the app"); },
        ];

    if ([scenario isEqualToString:@"lifecycle-views-background"])
        return @[
            ^{ PresentTitled(@"ViewAcrossBackground"); },
            ^{ NSLog(@"[SCENARIO] waiting for the harness to background the app"); },
        ];

    // --- request ordering ----------------------------------------------------

    if ([scenario isEqualToString:@"ordering-profile-events"])
        return @[
            // A user property set and then an event recorded. The server applies
            // requests in the order it receives them, so an event that lands before
            // the property is attributed to a user who does not have it yet.
            ^{ [cly.userProfile setProperty:@"name" value:@"Ordered Tester"]; },
            ^{ [cly.userProfile setProperty:@"tier" value:@"gold"]; },
            ^{ [cly recordEvent:@"after_profile_change"]; },
            ^{ [cly attemptToSendStoredRequests]; },
            // And the reverse: a property set with an event already pending.
            ^{ [cly recordEvent:@"before_profile_change"]; },
            ^{ [cly.userProfile setProperty:@"tier" value:@"platinum"]; },
            ^{ [cly.userProfile save]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"migration-seed-cache"])
        return @[
            ^{ [cly.remoteConfig downloadKeys:nil]; },
            ^{ NSLog(@"[SCENARIO] seeded RC count: %lu", (unsigned long)[cly.remoteConfig getAllValues].count); },
            // Bumps the health tracker's error and warning counters, which are
            // persisted and reported on the next launch.
            ^{ [cly recordEvent:@""]; },
            ^{ [cly.views stopViewWithName:@"NeverStarted" segmentation:nil]; },
            ^{ [cly recordEvent:@"seeded_cache_event"]; },
            ^{ [cly attemptToSendStoredRequests]; },
        ];

    if ([scenario isEqualToString:@"migration-seed"])
        return @[
            ^{ [cly recordEvent:@"seeded_before_migration_one"]; },
            ^{ [cly recordEvent:@"seeded_before_migration_two"]; },
            ^{ [cly.userProfile setProperty:@"name" value:@"Migrated User"]; },
            ^{ [cly.userProfile save]; },
            ^{ [cly attemptToSendStoredRequests]; },
            ^{ NSLog(@"[SCENARIO] seeded device ID: %@", cly.deviceIDType); },
        ];

    NSLog(@"[SCENARIO] unknown scenario: %@", scenario);
    return @[];
}

@implementation AppDelegate (CountlyScenarios)

- (void)runScenario
{
    NSString* scenario = CountlyScenarioName();
    NSArray<dispatch_block_t>* steps = StepsForScenario(scenario);

    NSLog(@"[SCENARIO] starting [%@], stepCount: %lu", scenario, (unsigned long)steps.count);
    RunSteps(steps, 0, 0.5);
}

@end
