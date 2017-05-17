// UserDetailsCustomModifiersViewController.m
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

#import "UserDetailsCustomModifiersViewController.h"
#import "Countly.h"

@interface UserDetailsCustomModifiersViewController ()
{
    NSArray* listOfCustomModifiers;
}
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@end

@implementation UserDetailsCustomModifiersViewController

static NSMutableArray* addedModifiers;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(!addedModifiers)
        addedModifiers = NSMutableArray.new;
    
    self.title = @"Custom Property Modifiers";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onClick_cancel:)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.redColor} forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onClick_save:)];
    
    listOfCustomModifiers =
    @[
        @"set",
        @"setOnce",
        @"unSet",
        @"increment",
        @"incrementBy",
        @"multiply",
        @"max",
        @"min",
        @"push",
        @"pushUnique",
        @"pull",
    ];

    self.tableView.tableFooterView = UIView.new;
    [self.tableView reloadData];
}


- (void)onClick_cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)onClick_save:(id)sender
{
    [Countly.user save];
    
    addedModifiers = NSMutableArray.new;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = 0;

    switch (indexPath.section)
    {
        case 0: height = 34; break;
        case 1: height = 50; break;
    }

    return height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;

    switch (section)
    {
        case 0: numberOfRows = listOfCustomModifiers.count; break;
        case 1: numberOfRows = addedModifiers.count; break;
    }

    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = nil;

    switch (indexPath.section)
    {
        case 0: identifier = @"DefaultCell"; break;
        case 1: identifier = @"UserDetailsCustomProperties"; break;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if(indexPath.section == 0)
    {
        cell.textLabel.text = listOfCustomModifiers[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-medium" size:14];
    }
    else if(indexPath.section == 1)
    {
        ((UILabel *)[cell viewWithTag:201]).text = addedModifiers[indexPath.row][@"k"];
        ((UILabel *)[cell viewWithTag:202]).text = addedModifiers[indexPath.row][@"v"];
        ((UILabel *)[cell viewWithTag:203]).text = addedModifiers[indexPath.row][@"m"];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        BOOL isOnlyKey = indexPath.row == 2 || indexPath.row == 3;
        BOOL isNumeric = indexPath.row >= 4 && indexPath.row <= 7;
    
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:listOfCustomModifiers[indexPath.row] message:isOnlyKey ? @"Enter key:":@"Enter key and value:" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField)
        {
            textField.placeholder = @"key";
        }];

        if(!isOnlyKey)
        {
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField)
            {
                textField.placeholder = @"value";
                if(isNumeric)
                    textField.keyboardType = UIKeyboardTypeDecimalPad;
            }];
        }

        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancel];
    
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
        {
            NSString* key = alertController.textFields[0].text;
            NSString* value = isOnlyKey ? @"" : alertController.textFields[1].text;

            if(key.length && (value.length || isOnlyKey))
            {
                switch (indexPath.row)
                {
                    case 0: [Countly.user set:key value:value]; break;
                    case 1: [Countly.user setOnce:key value:value]; break;
                    case 2: [Countly.user unSet:key]; break;
                    case 3: [Countly.user increment:key]; break;
                    case 4: [Countly.user incrementBy:key value:@([value doubleValue])]; break;
                    case 5: [Countly.user multiply:key value:@([value doubleValue])]; break;
                    case 6: [Countly.user max:key value:@([value doubleValue])]; break;
                    case 7: [Countly.user min:key value:@([value doubleValue])]; break;
                    case 8: [Countly.user push:key value:value]; break;
                    case 9: [Countly.user pushUnique:key value:value]; break;
                    case 10: [Countly.user pull:key value:value]; break;
                    default: break;
                }
            
                [addedModifiers addObject:@{@"k":key, @"v":value, @"m":listOfCustomModifiers[indexPath.row]}];
                [self reload];
            }
        }];

        [alertController addAction:ok];
    
        [self presentViewController:alertController animated:YES completion:nil];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)reload
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
