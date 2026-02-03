//
//  DeviceIdChangerViewController.m
//  CountlyTestApp-iOS
//
//  Created by Arif Burak Demiray on 4.12.2025.
//  Copyright © 2025 Countly. All rights reserved.
//

#import "DeviceIdChangerViewController.h"
#import "Countly.h"   // If you want to call Countly.deviceID().change()

@interface DeviceIdChangerViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *deviceIdField;
@property (nonatomic, strong) UIButton *applyButton;
@end

@implementation DeviceIdChangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Change Device ID";
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    [self setupUI];
}

- (void)setupUI {
    // ScrollView from superclass for keyboard handling
    UIScrollView *scroll = [UIScrollView new];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    self.keyboardInsetTargetView = scroll;
    [self.view addSubview:scroll];

    [NSLayoutConstraint activateConstraints:@[
        [scroll.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ]];

    // Content container
    UIView *content = [UIView new];
    content.translatesAutoresizingMaskIntoConstraints = NO;
    [scroll addSubview:content];

    [NSLayoutConstraint activateConstraints:@[
        [content.topAnchor constraintEqualToAnchor:scroll.topAnchor],
        [content.bottomAnchor constraintEqualToAnchor:scroll.bottomAnchor],
        [content.leadingAnchor constraintEqualToAnchor:scroll.leadingAnchor],
        [content.trailingAnchor constraintEqualToAnchor:scroll.trailingAnchor],
        [content.widthAnchor constraintEqualToAnchor:scroll.widthAnchor],
    ]];

    // TextField
    self.deviceIdField = [[UITextField alloc] init];
    self.deviceIdField.borderStyle = UITextBorderStyleRoundedRect;
    self.deviceIdField.placeholder = @"Enter new device ID";
    self.deviceIdField.translatesAutoresizingMaskIntoConstraints = NO;
    self.deviceIdField.delegate = self;
    [content addSubview:self.deviceIdField];

    // Button
    self.applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.applyButton setTitle:@"Change Device ID" forState:UIControlStateNormal];
    self.applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.applyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.applyButton addTarget:self action:@selector(applyTapped) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:self.applyButton];

    // Layout
    [NSLayoutConstraint activateConstraints:@[
        [self.deviceIdField.topAnchor constraintEqualToAnchor:content.safeAreaLayoutGuide.topAnchor constant:40],
        [self.deviceIdField.leadingAnchor constraintEqualToAnchor:content.leadingAnchor constant:20],
        [self.deviceIdField.trailingAnchor constraintEqualToAnchor:content.trailingAnchor constant:-20],
        [self.deviceIdField.heightAnchor constraintEqualToConstant:44],

        [self.applyButton.topAnchor constraintEqualToAnchor:self.deviceIdField.bottomAnchor constant:20],
        [self.applyButton.centerXAnchor constraintEqualToAnchor:content.centerXAnchor],
        [self.applyButton.bottomAnchor constraintLessThanOrEqualToAnchor:content.bottomAnchor constant:-20],
    ]];
}

#pragma mark - Button Action

- (void)applyTapped {
    NSString *newId = self.deviceIdField.text;

    if (newId.length == 0) {
        [self showAlert:@"Device ID cannot be empty."];
        return;
    }

    [Countly.sharedInstance setID:newId];
    [Countly.sharedInstance giveAllConsents];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}

#pragma mark - Helpers

- (void)showAlert:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Done"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];

    __weak typeof(self) weakSelf = self;

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
        // Close view after OK
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.navigationController &&
                weakSelf.navigationController.viewControllers.count > 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }];

    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
