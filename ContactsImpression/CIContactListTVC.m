//
//  CIContactListTVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-31.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIContactListTVC.h"
#import "PushViewController+UINavigationController.h"
#import "CITitleV.h"
#import "CIContactData.h"
#import "CIFriendVC.h"
#import "CISetEvaluateVC.h"

@interface CIContactListTVC ()

@property (nonatomic, retain) NSMutableArray *listContent;

@end

@implementation CIContactListTVC
@synthesize listContent = _listContent;

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.listContent = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    CITitleV *v = [[CITitleV alloc] initWithTitle:@"老友们"];
    [self.navigationItem setTitleView:v];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack setImageEdgeInsets:UIEdgeInsetsMake(0, -(44 - 5), 0, 0)];
    [btnBack addTarget:self action:@selector(OnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self performSelectorInBackground:@selector(SortData) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.listContent removeAllObjects];
}

-(void)OnBack:(id)sender
{
//    [self.navigationController popViewControllerWithTransitionType:@"push"
//                                                           SubType:@"fromLeft"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SortData
{
    [self.listContent removeAllObjects];
    NSMutableArray *addressBookTemp = [CIContactData contacts];
    // Sort data
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (PersonData *addressBook in addressBookTemp)
    {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(name)];
        addressBook.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++)
    {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (PersonData *addressBook in addressBookTemp)
    {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays)
    {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [self.listContent addObject:sortedSection];
    }
    [self performSelectorOnMainThread:@selector(ReloadTableView)
                           withObject:nil
                        waitUntilDone:NO];
}

-(void)ReloadTableView
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
            [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.listContent count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listContent objectAtIndex:section] count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0)
    {
        return 0;
    }
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.listContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [[self.listContent objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    PersonData *addressBook = (PersonData *)[[self.listContent
                                              objectAtIndex:indexPath.section]
                                             objectAtIndex:indexPath.row];
    
    if ([[addressBook.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0)
    {
        cell.textLabel.text = addressBook.name;
        cell.textLabel.textColor = UIColorFromARGB(0xff0c6024);
    }
    else
    {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:cell.textLabel.font.pointSize];
        cell.textLabel.text = [addressBook.phone objectAtIndex:0];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonData *addressBook = (PersonData *)[[self.listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    CIFriendVC *vc = [[CIFriendVC alloc] initWithData:addressBook];
//    [self.navigationController pushViewController:vc
//                                   TransitionType:@"push"
//                                          SubType:@"fromRight"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"\"老友说\"TA    ";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationRight];
    
    PersonData *addressBook = (PersonData *)[[self.listContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    CISetEvaluateVC *vc = [[CISetEvaluateVC alloc] initWithData:addressBook Type:CISetEvaluateType_Timeline];
//    [self.navigationController pushViewController:vc
//                                   TransitionType:@"push" SubType:@"fromRight"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
@end
