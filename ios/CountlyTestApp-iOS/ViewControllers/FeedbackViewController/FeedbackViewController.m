// FeedbackViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "FeedbackViewController.h"
#import "Countly.h"

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Feedback";

    self.tests = @[
        @{@"name": @"Ask for Star Rating", @"explanation": @""},
        @{@"name": @"Present NPS", @"explanation": @"No parameters"},
        @{@"name": @"Present NPS (by ID/tag)", @"explanation": @"Uses hardcoded widget identifier"},
        @{@"name": @"Present NPS (with callback)", @"explanation": @"With widget callback"},
        @{@"name": @"Present Survey", @"explanation": @"No parameters"},
        @{@"name": @"Present Survey (by ID/tag)", @"explanation": @"Uses hardcoded widget identifier"},
        @{@"name": @"Present Survey (with callback)", @"explanation": @"With widget callback"},
        @{@"name": @"Present Rating", @"explanation": @"No parameters"},
        @{@"name": @"Present Rating (by ID/tag)", @"explanation": @"Uses hardcoded widget identifier"},
        @{@"name": @"Present Rating (with callback)", @"explanation": @"With widget callback"},
        @{@"name": @"Get Available Feedback Widgets", @"explanation": @"Fetches widget list from server"},
        @{@"name": @"Present Rating Widget by ID", @"explanation": @"Widget ID needs to be hardcoded"},
        @{@"name": @"Record Rating Widget Result", @"explanation": @"Manual rating recording"},
        @{@"name": @"Present First NPS from Widget List", @"explanation": @"Fetch widgets then present first NPS"},
        @{@"name": @"Present First Survey from Widget List", @"explanation": @"Fetch widgets then present first Survey"},
    ];
}

- (void)handleTestAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: [Countly.sharedInstance askForStarRating:^(NSInteger rating) { NSLog(@"rating %d", (int)rating); }]; break;
        case 1: [Countly.sharedInstance.feedback presentNPS]; break;
        case 2: [Countly.sharedInstance.feedback presentNPS:@"nps_widget_id"]; break;
        case 3: [Countly.sharedInstance.feedback presentNPS:@"nps_widget_id" widgetCallback:^(WidgetState state) {
            NSLog(@"NPS Widget state: %lu", (unsigned long)state);
        }]; break;

        case 4: [Countly.sharedInstance.feedback presentSurvey]; break;
        case 5: [Countly.sharedInstance.feedback presentSurvey:@"survey_widget_id"]; break;
        case 6: [Countly.sharedInstance.feedback presentSurvey:@"survey_widget_id" widgetCallback:^(WidgetState state) {
            NSLog(@"Survey Widget state: %lu", (unsigned long)state);
        }]; break;

        case 7: [Countly.sharedInstance.feedback presentRating]; break;
        case 8: [Countly.sharedInstance.feedback presentRating:@"rating_widget_id"]; break;
        case 9: [Countly.sharedInstance.feedback presentRating:@"rating_widget_id" widgetCallback:^(WidgetState state) {
            NSLog(@"Rating Widget state: %lu", (unsigned long)state);
        }]; break;

        case 10:
        {
            [Countly.sharedInstance.feedback getAvailableFeedbackWidgets:^(NSArray<CountlyFeedbackWidget *> *feedbackWidgets, NSError *error) {
                if (error)
                {
                    NSLog(@"Getting widgets list failed. Error: %@", error);
                }
                else
                {
                    NSLog(@"Available feedback widgets: %@", feedbackWidgets);
                    for (CountlyFeedbackWidget *widget in feedbackWidgets)
                    {
                        NSLog(@"Widget: %@ - %@ - %@", widget.type, widget.ID, widget.name);
                    }
                }
            }];
        } break;

        case 11:
        {
            [Countly.sharedInstance presentRatingWidgetWithID:@"RATING_WIDGET_ID" completionHandler:^(NSError *error) {
                if (error) NSLog(@"Rating widget error: %@", error);
                else NSLog(@"Rating widget dismissed");
            }];
        } break;

        case 12:
        {
            [Countly.sharedInstance recordRatingWidgetWithID:@"RATING_WIDGET_ID" rating:5 email:@"test@test.com" comment:@"Great app!" userCanBeContacted:YES];
        } break;

        case 13: [self presentFirstWidgetOfType:CLYFeedbackWidgetTypeNPS]; break;
        case 14: [self presentFirstWidgetOfType:CLYFeedbackWidgetTypeSurvey]; break;

        default: break;
    }
}

- (void)presentFirstWidgetOfType:(CLYFeedbackWidgetType)widgetType
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [Countly.sharedInstance getFeedbackWidgets:^(NSArray *feedbackWidgets, NSError *error) {
        if (error)
        {
            NSLog(@"Getting widgets list failed. Error: %@", error);
        }
        else
        {
            for (CountlyFeedbackWidget *feedbackWidget in feedbackWidgets)
            {
                if ([widgetType isEqualToString:feedbackWidget.type])
                {
                    [feedbackWidget presentWithAppearBlock:^{
                        NSLog(@"Appeared!");
                    } andDismissBlock:^{
                        NSLog(@"Dismissed!");
                    }];
                    break;
                }
            }
        }
    }];
#pragma clang diagnostic pop
}

@end
