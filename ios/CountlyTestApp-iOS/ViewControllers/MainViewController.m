// MainViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "MainViewController.h"
#import "Countly.h"
#import "SectionTestViewController.h"

#import "ContentBuilderViewController.h"
#import "CustomEventsViewController.h"
#import "CrashReportingViewController.h"
#import "UserDetailsSectionViewController.h"
#import "APMViewController.h"
#import "ViewTrackingViewController.h"
#import "PushNotificationsViewController.h"
#import "LocationViewController.h"
#import "MultithreadingViewController.h"
#import "ConsentsViewController.h"
#import "RemoteConfigViewController.h"
#import "FeedbackViewController.h"
#import "AttributionViewController.h"
#import "QueueOperationsViewController.h"
#import "SDKLifecycleViewController.h"

static NSString *const kCellIdentifier = @"MainCell";
static NSString *const kHeaderIdentifier = @"MainHeader";

@interface MainViewController ()
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray<NSDictionary *> *sectionGroups;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Countly";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

    [self setupNavigationBar];
    [self setupSections];
    [self setupCollectionView];
    [self copyBundlePictures];
}

#pragma mark - Setup

- (void)setupNavigationBar
{
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationController.navigationBar.prefersLargeTitles = YES;

    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    [appearance configureWithDefaultBackground];
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    self.navigationController.navigationBar.standardAppearance = appearance;
}

- (void)setupSections
{
    self.sectionGroups = @[
        @{
            @"title": @"Data & Events",
            @"items": @[
                @{@"name": @"Custom Events",     @"icon": @"list.bullet.rectangle", @"class": CustomEventsViewController.class,       @"color": UIColor.systemBlueColor},
                @{@"name": @"Remote Config",      @"icon": @"gearshape.2",           @"class": RemoteConfigViewController.class,      @"color": UIColor.systemIndigoColor},
                @{@"name": @"Content Builder",    @"icon": @"doc.richtext",           @"class": ContentBuilderViewController.class,    @"color": UIColor.systemCyanColor},
            ]
        },
        @{
            @"title": @"User & Analytics",
            @"items": @[
                @{@"name": @"User Details",       @"icon": @"person.crop.circle",     @"class": UserDetailsSectionViewController.class, @"color": UIColor.systemPurpleColor},
                @{@"name": @"View Tracking",      @"icon": @"eye",                    @"class": ViewTrackingViewController.class,       @"color": UIColor.systemTealColor},
                @{@"name": @"Attribution",         @"icon": @"link",                   @"class": AttributionViewController.class,        @"color": UIColor.systemBrownColor},
            ]
        },
        @{
            @"title": @"Stability & Performance",
            @"items": @[
                @{@"name": @"Crash Reporting",    @"icon": @"exclamationmark.triangle", @"class": CrashReportingViewController.class, @"color": UIColor.systemRedColor},
                @{@"name": @"APM",                @"icon": @"speedometer",              @"class": APMViewController.class,             @"color": UIColor.systemOrangeColor},
            ]
        },
        @{
            @"title": @"Engagement",
            @"items": @[
                @{@"name": @"Push Notifications", @"icon": @"bell.badge",              @"class": PushNotificationsViewController.class, @"color": UIColor.systemPinkColor},
                @{@"name": @"Feedback",            @"icon": @"star.bubble",             @"class": FeedbackViewController.class,          @"color": UIColor.systemYellowColor},
                @{@"name": @"Location",            @"icon": @"location",                @"class": LocationViewController.class,          @"color": UIColor.systemGreenColor},
            ]
        },
        @{
            @"title": @"SDK Management",
            @"items": @[
                @{@"name": @"Consents",           @"icon": @"checkmark.shield",        @"class": ConsentsViewController.class,          @"color": UIColor.systemMintColor},
                @{@"name": @"Queue Operations",   @"icon": @"tray.2",                  @"class": QueueOperationsViewController.class,   @"color": UIColor.systemGrayColor},
                @{@"name": @"SDK Lifecycle",       @"icon": @"power",                   @"class": SDKLifecycleViewController.class,      @"color": UIColor.systemRedColor},
                @{@"name": @"Multithreading",      @"icon": @"cpu",                     @"class": MultithreadingViewController.class,    @"color": UIColor.systemIndigoColor},
            ]
        },
    ];
}

- (void)setupCollectionView
{
    UICollectionViewCompositionalLayout *layout = [self createLayout];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:kHeaderIdentifier];

    [self.view addSubview:self.collectionView];
}

- (UICollectionViewCompositionalLayout *)createLayout
{
    UICollectionViewCompositionalLayoutConfiguration *config = [UICollectionViewCompositionalLayoutConfiguration new];
    config.interSectionSpacing = 24;

    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection *(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment> environment) {

        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                         heightDimension:[NSCollectionLayoutDimension estimatedDimension:72]];
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];

        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                          heightDimension:[NSCollectionLayoutDimension estimatedDimension:72]];
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitem:item count:1];

        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        section.contentInsets = NSDirectionalEdgeInsetsMake(0, 16, 0, 16);
        section.interGroupSpacing = 1;

        NSCollectionLayoutSize *headerSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                           heightDimension:[NSCollectionLayoutDimension estimatedDimension:40]];
        NSCollectionLayoutBoundarySupplementaryItem *header = [NSCollectionLayoutBoundarySupplementaryItem
            boundarySupplementaryItemWithLayoutSize:headerSize
            elementKind:UICollectionElementKindSectionHeader
            alignment:NSRectAlignmentTop];
        section.boundarySupplementaryItems = @[header];

        return section;
    } configuration:config];

    return layout;
}

#pragma mark - Cell Configuration

- (UIView *)createCellContentForItem:(NSDictionary *)item isFirst:(BOOL)isFirst isLast:(BOOL)isLast
{
    // Container with rounded corners
    UIView *container = [UIView new];
    container.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    container.translatesAutoresizingMaskIntoConstraints = NO;

    // Icon background circle
    UIView *iconBg = [UIView new];
    iconBg.backgroundColor = item[@"color"];
    iconBg.layer.cornerRadius = 16;
    iconBg.translatesAutoresizingMaskIntoConstraints = NO;

    // Icon image
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:item[@"icon"] withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:18 weight:UIImageSymbolWeightMedium]]];
    iconView.tintColor = [UIColor whiteColor];
    iconView.contentMode = UIViewContentModeCenter;
    iconView.translatesAutoresizingMaskIntoConstraints = NO;

    // Title label
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = item[@"name"];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor labelColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // Chevron
    UIImageView *chevron = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:13 weight:UIImageSymbolWeightMedium]]];
    chevron.tintColor = [UIColor tertiaryLabelColor];
    chevron.translatesAutoresizingMaskIntoConstraints = NO;

    // Separator
    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor separatorColor];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.hidden = isLast;

    [iconBg addSubview:iconView];
    [container addSubview:iconBg];
    [container addSubview:titleLabel];
    [container addSubview:chevron];
    [container addSubview:separator];

    [NSLayoutConstraint activateConstraints:@[
        [iconView.centerXAnchor constraintEqualToAnchor:iconBg.centerXAnchor],
        [iconView.centerYAnchor constraintEqualToAnchor:iconBg.centerYAnchor],

        [iconBg.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:16],
        [iconBg.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [iconBg.widthAnchor constraintEqualToConstant:32],
        [iconBg.heightAnchor constraintEqualToConstant:32],

        [titleLabel.leadingAnchor constraintEqualToAnchor:iconBg.trailingAnchor constant:14],
        [titleLabel.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:chevron.leadingAnchor constant:-8],

        [chevron.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-16],
        [chevron.centerYAnchor constraintEqualToAnchor:container.centerYAnchor],

        [separator.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [separator.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [separator.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [separator.heightAnchor constraintEqualToConstant:1.0 / UIScreen.mainScreen.scale],

        [container.heightAnchor constraintEqualToConstant:52],
    ]];

    // Rounded corners for first/last items
    if (isFirst || isLast)
    {
        CACornerMask corners = 0;
        if (isFirst) corners |= (kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner);
        if (isLast) corners |= (kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner);
        container.layer.cornerRadius = 12;
        container.layer.maskedCorners = corners;
        container.clipsToBounds = YES;
    }

    return container;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionGroups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.sectionGroups[section][@"items"] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];

    // Remove old content
    for (UIView *subview in cell.contentView.subviews)
        [subview removeFromSuperview];

    NSArray *items = self.sectionGroups[indexPath.section][@"items"];
    NSDictionary *item = items[indexPath.row];
    BOOL isFirst = (indexPath.row == 0);
    BOOL isLast = (indexPath.row == (NSInteger)items.count - 1);

    UIView *content = [self createCellContentForItem:item isFirst:isFirst isLast:isLast];
    [cell.contentView addSubview:content];

    [NSLayoutConstraint activateConstraints:@[
        [content.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor],
        [content.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor],
        [content.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor],
        [content.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor],
    ]];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];

    for (UIView *subview in header.subviews)
        [subview removeFromSuperview];

    UILabel *label = [UILabel new];
    label.text = [self.sectionGroups[indexPath.section][@"title"] uppercaseString];
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    label.textColor = [UIColor secondaryLabelColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [header addSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:16],
        [label.bottomAnchor constraintEqualToAnchor:header.bottomAnchor constant:-6],
    ]];

    return header;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.sectionGroups[indexPath.section][@"items"][indexPath.row];
    Class vcClass = item[@"class"];
    SectionTestViewController *vc = [vcClass new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.1 animations:^{
        cell.contentView.alpha = 0.6;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.contentView.alpha = 1.0;
    }];
}

#pragma mark - Helpers

- (void)copyBundlePictures
{
    NSURL *documentsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSArray *fileTypes = @[@"gif", @"jpg", @"png"];
    for (NSString *fileType in fileTypes)
    {
        NSURL *bundleFileURL = [NSBundle.mainBundle URLForResource:@"SamplePicture" withExtension:fileType];
        NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:bundleFileURL.lastPathComponent];
        [NSFileManager.defaultManager copyItemAtURL:bundleFileURL toURL:destinationURL error:nil];
    }
}

@end
