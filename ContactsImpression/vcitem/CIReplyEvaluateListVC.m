//
//  CIReplyEvaluateListVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-5-24.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIReplyEvaluateListVC.h"
#import "CIReplyEvaluateListItemVC.h"

static int s_tag = 0;

@interface CIReplyEvaluateListVC ()

@property (nonatomic, retain) NSDictionary *timeline;
@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, retain) NSMutableArray *nets;
@property (nonatomic, assign) NSInteger page;

@end

@implementation CIReplyEvaluateListVC

- (id)initWithData:(NSDictionary*)data
{
    self = [super initWithNibName:@"CIReplyEvaluateListVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.timeline = data;
        self.datas = [[NSMutableArray alloc] init];
        self.nets = [[NSMutableArray alloc] init];
        self.page = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self.tbv setContentInset:UIEdgeInsetsMake(0, 0, -20, 0)];
    [self loadDataList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    for (NetServiceManager *net in self.nets)
    {
        [net CancelRequest];
    }
    [self.nets removeAllObjects];
}

-(void)loadDataList
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInteger:self.page] forKey:CTRL_PAGE];
    [dic setValue:[self.timeline objectForKey:CI_TID] forKey:CI_TID];
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:s_tag++];
    [net GetReplyList:dic];
    [self.nets addObject:net];
}

//tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *SimpleTableIdentifier = @"list_Reply";
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
    
    CIReplyEvaluateListItemVC *vc = [[CIReplyEvaluateListItemVC alloc] initWithReply:[self.datas objectAtIndex:indexPath.row]
                                                                               Index:indexPath.row];
    [cell.contentView addSubview:vc.view];
    vc.view.tag = 0x8010;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 5 == self.datas.count)
    {
        [self loadDataList];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CIReplyEvaluateListItemVC LabelHeighWithText:[self.datas objectAtIndex:indexPath.row]];
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

- (void)addReply:(NSString*)newReply
{
    [self.datas insertObject:newReply atIndex:0];
    [self performSelectorOnMainThread:@selector(reloadData)
                           withObject:nil
                        waitUntilDone:NO];
}

-(void)reloadData
{
    [self.tbv reloadData];
}

//net
-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    [self.nets RemoveObjectWithTag:tag];
}

-(void)ReplyListData:(id)data Tag:(NSInteger)tag
{
    [self.nets RemoveObjectWithTag:tag];
    int page = [[data objectForKey:CTRL_PAGE] intValue];
    id list = [data objectForKey:CI_LIST];
    if (self.page == page && list && [list count] > 0)
    {
        ++self.page;
        [self.datas addObjectsFromArray:list];
        [self performSelectorOnMainThread:@selector(reloadData)
                               withObject:nil
                            waitUntilDone:NO];
    }
}
@end
