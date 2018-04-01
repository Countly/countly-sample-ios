// UserDetailsEditorViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "UserDetailsEditorViewController.h"
#import "Countly.h"

@interface UserDetailsEditorViewController ()
{
    UITextField* txt_name;
    UITextField* txt_username;
    UITextField* txt_email;
    UITextField* txt_organization;
    UITextField* txt_phone;
    UITextField* txt_pictureURL;
    UITextField* txt_birthYear;
    UISegmentedControl* sgm_gender;
}
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic) NSMutableArray* custom;
@end

@implementation UserDetailsEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keyboardInsetTargetView = self.tableView;
    
    self.title = @"User Details";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onClick_cancel:)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.redColor} forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithTitle:@"Record" style:UIBarButtonItemStylePlain target:self action:@selector(onClick_record:)];

    self.custom = NSMutableArray.new;

    NSDictionary* userCustomProperties = (NSDictionary *)Countly.user.custom;
    for (NSString* key in userCustomProperties)
        [self.custom addObject:@{@"k": key, @"v": userCustomProperties[key]}];

    self.tableView.tableFooterView = UIView.new;
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    txt_name = [self.tableView viewWithTag:101];
    txt_username = [self.tableView viewWithTag:102];
    txt_email = [self.tableView viewWithTag:103];
    txt_organization = [self.tableView viewWithTag:104];
    txt_phone = [self.tableView viewWithTag:105];
    txt_pictureURL = [self.tableView viewWithTag:106];
    txt_birthYear = [self.tableView viewWithTag:107];
    sgm_gender = [self.tableView viewWithTag:108];

    txt_name.text = (NSString*)Countly.user.name;
    txt_username.text = (NSString*)Countly.user.username;
    txt_email.text = (NSString*)Countly.user.email;
    txt_organization.text = (NSString*)Countly.user.organization;
    txt_phone.text = (NSString*)Countly.user.phone;
    txt_pictureURL.text = (NSString*)Countly.user.pictureURL;
    txt_birthYear.text = Countly.user.birthYear.description;
    sgm_gender.selectedSegmentIndex = [(NSString*)Countly.user.gender isEqualToString:@"M"] ? 0 : [(NSString*)Countly.user.gender isEqualToString:@"F"] ? 1 : -1 ;
}


- (void)onClick_cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)onClick_record:(id)sender
{
    Countly.user.name = txt_name.text.length ? txt_name.text : nil;
    Countly.user.username = txt_username.text.length ? txt_username.text : nil;
    Countly.user.email = txt_email.text.length ? txt_email.text : nil;
    Countly.user.organization = txt_organization.text.length ? txt_organization.text : nil;
    Countly.user.phone = txt_phone.text.length ? txt_phone.text : nil;
    Countly.user.pictureURL = txt_pictureURL.text.length ? txt_pictureURL.text : nil;
    Countly.user.birthYear = txt_birthYear.text.length ? @(txt_birthYear.text.integerValue) : nil;
    Countly.user.gender = (sgm_gender.selectedSegmentIndex == 0) ? @"M" : (sgm_gender.selectedSegmentIndex == 1) ? @"F" : nil;

    NSMutableDictionary* cust = self.custom.count ? NSMutableDictionary.new : nil;
    for (NSDictionary* dict in self.custom)
        cust[dict[@"k"]] = dict[@"v"];
    Countly.user.custom = cust;

    [Countly.user save];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark ---


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 0;

    switch (indexPath.section)
    {
        case 0: height = 590; break;
        case 1: height = 44; break;
    }

    return height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;

    switch (section)
    {
        case 0: numberOfRows = 1; break;
        case 1: numberOfRows = self.custom.count + 1; break;
    }

    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = nil;

    switch (indexPath.section)
    {
        case 0: identifier = @"UserDetailsDefaultProperties"; break;
        case 1: identifier = @"UserDetailsCustomProperties";
                if(indexPath.row == self.custom.count)
                    identifier = @"UserDetailsCustomPropertiesAdd";
        break;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if(indexPath.section == 1 && indexPath.row != self.custom.count)
    {
        ((UILabel *)[cell viewWithTag:201]).text = self.custom[indexPath.row][@"k"];
        ((UILabel *)[cell viewWithTag:202]).text = self.custom[indexPath.row][@"v"];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(indexPath.row == self.custom.count)
        {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Add Custom Property" message:@"Enter custom property key and value:" preferredStyle:UIAlertControllerStyleAlert];

            [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField)
            {
                textField.placeholder = @"key";
            }];

            [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField)
            {
                textField.placeholder = @"value";
            }];


            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancel];
        
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
            {
                NSString* key = alertController.textFields[0].text;
                NSString* value = alertController.textFields[1].text;
                if(key.length && value.length)
                {
                    [self.custom addObject:@{@"k":key, @"v":value}];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];

            [alertController addAction:ok];
        
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            [self.custom removeObjectAtIndex:indexPath.row];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
