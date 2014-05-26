//
//  CIEvaluateListVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-31.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIEvaluateListVC.h"
#import "CIContactData.h"
#import "CINoEvaluateItemVC.h"
#import "CIReviewListVC.h"

extern NSInteger s_maxReadNum;

@interface CIEvaluateListVC ()

@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) CINoEvaluateItemVC *vc_noEvaluate;

@end

@implementation CIEvaluateListVC
@synthesize datas = _datas;
@synthesize frame = _frame;

- (id)initWithFrame:(CGRect)frame Type:(EvaluateListItemType)type
{
    self = [super initWithNibName:@"CIEvaluateListVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.frame = frame;
        self.type = type;
        self.index = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tbv.pullDelegate = self;
    self.tbv.pullArrowImage = [UIImage imageNamed:@"whiteArrow.png"];
    self.tbv.pullBackgroundColor = UIColorFromARGB(0xff036122);
    self.tbv.pullTextColor = UIColorFromARGB(0xffffffff);
    
    
    [self.view setFrame:self.frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DataLoadOver
{
    [self performSelector:@selector(hideLoaddingTitle) withObject:nil afterDelay:1.0];
//    [self performSelectorOnMainThread:@selector(hideLoaddingTitle) withObject:nil waitUntilDone:NO];
}

-(void)DataLoadStart
{
    [self performSelectorOnMainThread:@selector(ShowLoaddingTitle) withObject:nil waitUntilDone:NO];
}

-(void)ShowLoaddingTitle
{
    self.tbv.pullTableIsRefreshing = YES;
    [self pullTableViewDidTriggerRefresh:self.tbv];
}

-(void)hideLoaddingTitle
{
    self.tbv.pullTableIsRefreshing = NO;
    self.tbv.pullTableIsLoadingMore = NO;
}

//tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.datas count] == 0)
    {
        NSString *tip = @"老友们都没有被说过？\n点我去说下老友！";
        if (self.type == EvaluateListItemType_Friend)
        {
            tip = @"TA还没被说过呢!\n点我去说下TA吧！";
        }
        else if (self.type == EvaluateListItemType_Self)
        {
            tip = @"你没有被老友们说过\n点我去说下老友们！";
        }
        self.vc_noEvaluate = [[CINoEvaluateItemVC alloc] initWithTip:tip];
        return 1;
    }
    self.vc_noEvaluate = nil;
    return [self.datas count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.vc_noEvaluate != nil)
    {//没有信息，显示提示
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoEvaluate"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: @"NoEvaluate"];
        }
        else
        {
            return cell;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.vc_noEvaluate.view];
        return cell;
    }
    NSString *SimpleTableIdentifier = @"list_TableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
    }
    else
    {
        
        [[cell.contentView viewWithTag:0x8010] removeFromSuperview];
    }
    
    cell.tag = indexPath.row;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [self.datas objectAtIndex:indexPath.row];
    CIEvaluateListItemVC *vc = [[CIEvaluateListItemVC alloc] initWithData:dic
                                                                     Type:self.type
                                                                    Index:indexPath.row];
    [cell.contentView addSubview:vc.view];
    vc.view.tag = 0x8010;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.vc_noEvaluate == nil)
    {
        return 140;
    }
    return 200;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.vc_noEvaluate != nil)
    {
        return NO;
    }
    NSDictionary *dic = [self.datas objectAtIndex:indexPath.row];
    id read = [dic objectForKey:CI_READ];
    if (read && [read integerValue] == 1)
    {
        return NO;
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [[UserDef getUserDefValue:LAST_WATCH_Count] integerValue];
    NSInteger c = s_maxReadNum - count;
    if (c <= 0)
    {
        NSInteger count = [[UserDef getUserDefValue:LAST_EVALUATE_Count] integerValue];
        if (count != 0)
        {
            return [NSString stringWithFormat:@"今日查看\n已达上限"];
        }
        return [NSString stringWithFormat:@"评价好友\n可查看更多"];
    }
    return [NSString stringWithFormat:@"今日剩余%ld条\n点击查看", (long)c];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //计算今日可查看量
    NSInteger count = [[UserDef getUserDefValue:LAST_WATCH_Count] integerValue];
    NSInteger max = s_maxReadNum;
//    NSString *str = [UserDef getUserDefValue:USER_NAME];
//    if (str && str.length > 0)
//    {
//        max = 3;
//    }
    
    if (max > count)
    {
        [UserDef setUserDefValue:[NSNumber numberWithInteger:++count] keyName:LAST_WATCH_Count];
        [UserDef setUserDefValue:[NSDate date] keyName:LAST_WATCH_Date];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.datas objectAtIndex:indexPath.row]];
        [dic setValue:[NSNumber numberWithInteger:1] forKey:CI_READ];
        [self.datas replaceObjectAtIndex:indexPath.row withObject:dic];
        
        if ([self.delegate respondsToSelector:@selector(ReadEvaluate:EvaluateData:)])
        {
            [self.delegate ReadEvaluate:self EvaluateData:dic];
        }
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationRight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.vc_noEvaluate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(SelectNoEvaluate:)])
        {
            [self.delegate SelectNoEvaluate:self];
        }
        return;
    }
    NSDictionary *dic = [self.datas objectAtIndex:indexPath.row];
    id read = [dic objectForKey:CI_READ];
    if (read && [read integerValue] == 1)
    {
        if ([self.delegate respondsToSelector:@selector(SelectEvaluate:EvaluateData:)])
        {
            [self.delegate SelectEvaluate:self EvaluateData:dic];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat last_y = 0.0;
    static int downORup = 0;
    if (scrollView.contentOffset.y > last_y + 30)
    {//向上
        last_y = scrollView.contentOffset.y;
        if (downORup != 1)
        {
            downORup = 1;
            if ([self.delegate respondsToSelector:@selector(ScrollUp:)])
            {
                [self.delegate ScrollUp:self];
            }
        }
    }
    else if (scrollView.contentOffset.y < last_y - 60)
    {//向下50
        last_y = scrollView.contentOffset.y;
        if (downORup != 2)
        {
            downORup = 2;
            if ([self.delegate respondsToSelector:@selector(ScrollDown:)])
            {
                [self.delegate ScrollDown:self];
            }
        }
    }
}

-(void)ReloadTableViewWithData:(NSMutableArray*)arr
{
    [self DataLoadOver];
    self.datas = arr;
    [self.tbv reloadData];
    self.tbv.pullLastRefreshDate = [NSDate date];
}

#pragma mark - PullTableViewDelegate
-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    if ([self.delegate respondsToSelector:@selector(RefreshEvaluateList:)])
    {
        [self.delegate RefreshEvaluateList:self];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{//上拉更多
    if ([self.delegate respondsToSelector:@selector(LoadmoreEvaluateList:)])
    {
        [self.delegate LoadmoreEvaluateList:self];
    }
}

@end
