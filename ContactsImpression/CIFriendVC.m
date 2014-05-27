//
//  CIFriendVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-31.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIFriendVC.h"
#import "PushViewController+UINavigationController.h"
#import "PersonData.h"
#import "CITitleV.h"
#import "CIReadEvaluateVC.h"

static int s_tag = 0;

@interface CIFriendVC ()

@property (nonatomic, retain) CIEvaluateListVC *vc_evaluate;
@property (nonatomic, assign) NSInteger iPage;
@property (nonatomic, retain) NSMutableArray *datas;
@property (nonatomic, retain) NSMutableArray *nets;
@property (nonatomic, retain) PersonData *personData;
@property (nonatomic, retain) CISetEvaluateVC *vc_setEvaluate;
@property (nonatomic, assign) BOOL bNeedReload;

@end

@implementation CIFriendVC
@synthesize vc_evaluate = _vc_evaluate;
@synthesize datas = _datas;
@synthesize iPage = _iPage;
@synthesize personData = _personData;
@synthesize vc_setEvaluate = _vc_setEvaluate;

- (id)initWithData:(id)data
{
    self = [super initWithNibName:@"CIFriendVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.datas = [[NSMutableArray alloc] init];
        self.nets = [[NSMutableArray alloc] init];
        self.personData = data;
        self.bNeedReload = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack setImageEdgeInsets:UIEdgeInsetsMake(0, -(44 - 5), 0, 0)];
    [btnBack addTarget:self action:@selector(OnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOK setFrame:CGRectMake(0, 0, 44, 44)];
    [btnOK setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [btnOK setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(44 - 10))];
    [btnOK addTarget:self action:@selector(OnEdit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *OKItem = [[UIBarButtonItem alloc] initWithCustomView:btnOK];
    self.navigationItem.rightBarButtonItem = OKItem;
    
    NSString *name = self.personData.name;
    if (name.length == 0)
    {
        name = [self.personData.phone objectAtIndex:0];
    }
    CITitleV *title = [[CITitleV alloc] initWithTitle:name];
    [self.navigationItem setTitleView:title];
    
    CGRect frame = [[UIScreen mainScreen] bounds] ;
    frame.origin = CGPointZero;
    self.vc_evaluate = [[CIEvaluateListVC alloc] initWithFrame:frame Type:EvaluateListItemType_Friend];
    [self.vc_evaluate setDelegate:self];
    [self.view addSubview:self.vc_evaluate.view];
    
    self.iPage = 0;
    [self getEvaluateData];
    
    //刷新某一条
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTidData:)
                                                 name:@"Notification_TID_refresh"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (NetServiceManager *net in self.nets) {
        [net CancelRequest];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.bNeedReload) {
        [self.vc_evaluate ReloadTableViewWithData:self.datas];
    }
}

-(void)getEvaluateData
{
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInteger:self.iPage] forKey:CTRL_PAGE];
    [dic setValue:[NSNumber numberWithInteger:self.personData.pid] forKey:CI_PID];
    [net GetEvaluate:dic];
    [self.nets addObject:net];
}

-(void)OnBack:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (NetServiceManager *net in self.nets) {
        [net CancelRequest];
    }
    [self.nets removeAllObjects];
    [self.datas removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
    self.personData = nil;
    self.vc_setEvaluate = nil;
}

-(void)OnEdit:(id)sender
{
    CISetEvaluateVC *vc = [[CISetEvaluateVC alloc] initWithData:self.personData Type:CISetEvaluateType_Timeline];
    [vc setDelegate:self];
//    [self.navigationController pushViewController:vc
//                                   TransitionType:@"push" SubType:@"fromRight"];
    [self.navigationController pushViewController:vc animated:YES];
    self.vc_setEvaluate = vc;
}

-(void)SelectEvaluate:(CIEvaluateListVC *)evaluateListVC EvaluateData:(id)data
{
    CIReadEvaluateVC *vc = [[CIReadEvaluateVC alloc] initWithData:data Type:evaluateListVC.type];
//    [self.navigationController pushViewController:vc
//                                   TransitionType:@"push"
//                                          SubType:@"fromRight"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)SelectNoEvaluate:(CIEvaluateListVC *)evaluateListVC
{
    [self OnEdit:nil];
}

-(void)SetEvaluate:(CISetEvaluateVC *)vc Data:(id)data
{
    [self.datas insertObject:data atIndex:0];
    self.bNeedReload = YES;
}

-(void)RefreshEvaluateList:(CIEvaluateListVC *)evaluateListVC
{
    self.iPage = 0;
    [self getEvaluateData];
}

-(void)LoadmoreEvaluateList:(CIEvaluateListVC *)evaluateListVC
{
    [self getEvaluateData];
}

- (void)refreshTidData: (NSNotification*) aNotification
{
    NSString *tid = [aNotification.userInfo objectForKey:CI_TID];
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    [net GetTimelineOne:[[NSMutableDictionary alloc] initWithObjectsAndKeys:tid, CI_TID, nil]];
    [self.nets addObject:net];
}

-(void)ReadEvaluate:(CIEvaluateListVC *)evaluateListVC EvaluateData:(id)data
{
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    [net SetReadEvaluate:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[data objectForKey:CI_TID], CI_TID, nil]];
    [self.nets addObject:net];
}

-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    [self.nets RemoveObjectWithTag:tag];
    [self.vc_evaluate DataLoadOver];
}

-(void)EvaluateData:(id)data Tag:(NSInteger)tag
{
    [self.nets RemoveObjectWithTag:tag];
    [self.vc_evaluate DataLoadOver];
    NSInteger pg = [[data objectForKey:CTRL_PAGE] integerValue];
    if (pg == self.iPage)
    {
        id arr = [data objectForKey:CI_LIST];
        if ([arr count] > 0)
        {
            if (self.iPage == 0)
            {
                [self.datas removeAllObjects];
            }
            [self.datas addObjectsFromArray:arr];
            ++self.iPage;
            [self.vc_evaluate ReloadTableViewWithData:self.datas];
        }
    }
}

-(void)TimeLineOneData:(id)data Tag:(NSInteger)tag
{
    NSString *tid = [data objectForKey:CI_TID];
    if (tid == nil || tid.length == 0) {
        return;
    }
    /**
     *  替换所有相关的tid
     */
    for (int i = 0; i < self.datas.count; ++i)
    {
        if ([tid isEqualToString:[[self.datas objectAtIndex:i] objectForKey:CI_TID]])
        {
            [self.datas replaceObjectAtIndex:i withObject:data];
            [self.vc_evaluate ReloadTableViewWithData:self.datas];
            break;
        }
    }
}

-(void)SetReadEvaluateData:(id)data Tag:(NSInteger)tag
{
    [self.nets RemoveObjectWithTag:tag];
}
@end
