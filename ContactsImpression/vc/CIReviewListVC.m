//
//  CIReviewListVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-24.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIReviewListVC.h"
#import "PushViewController+UINavigationController.h"
#import "CITitleV.h"
#import "CIContactData.h"
#import "CIContactListTVC.h"
#import "CIEvaluateListVC.h"
#import "JSONKit.h"
#import "CIReadEvaluateVC.h"
#import "HSLoaddingVC.h"

static int s_tag = 0;
static int s_tagUpload = -1;
NSInteger s_maxReadNum = 0;
NSInteger s_maxEvaluateNum = 0;

@interface CIReviewListVC ()

@property (nonatomic, retain) CILoginVC *loginVC;
@property (nonatomic, retain) NSMutableArray *nets;
@property (nonatomic, retain) CIEvaluateListVC *vc_timeline;
@property (nonatomic, retain) NSMutableArray *timeline_datas;
@property (nonatomic, assign) NSInteger i_timelinePage;
@property (nonatomic, retain) CIEvaluateListVC *vc_myevaluate;
@property (nonatomic, retain) NSMutableArray *trend_datas;
@property (nonatomic, assign) NSInteger i_trendPage;
@property (nonatomic, assign) BOOL bCanLoad;
@property (nonatomic, retain) HSLoaddingVC *loadding;
@property (nonatomic, retain) CIMoreVC *vc_more;

@property (nonatomic, strong) CIContactData *contactData;
@property (nonatomic, retain) NSArray *phones;

@property (nonatomic, assign) int iUserInfoTag;
@property (nonatomic, assign) int iNeedHideLoad;
@property (nonatomic, assign) BOOL bIsLogoutBack;
@property (nonatomic, assign) BOOL bIsLoginBack;


@property (nonatomic, assign) BOOL bIsShowRelogin;;

@end

@implementation CIReviewListVC
@synthesize loginVC = _loginVC;
@synthesize nets = _nets;
@synthesize vc_timeline = _vc_timeline;
@synthesize timeline_datas = _timeline_datas;
@synthesize i_timelinePage = _i_timelinePage;
@synthesize vc_myevaluate = _vc_myevaluate;
@synthesize trend_datas = _trend_datas;
@synthesize i_trendPage = _i_trendPage;
@synthesize loadding = _loadding;
@synthesize vc_more = _vc_more;

- (id)init
{
    self = [super initWithNibName:@"CIReviewListVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.nets = [[NSMutableArray alloc] init];
        self.timeline_datas = [[NSMutableArray alloc] init];
        self.bCanLoad = NO;
        self.iNeedHideLoad = 0;
        self.bIsLogoutBack = NO;
        self.bIsLoginBack = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *img = [UIImage imageNamed:@"more.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [button addTarget:self action:@selector(OnMore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    CGRect frame = [[UIScreen mainScreen] bounds] ;
    frame.size.height -= 64; //底+顶
    frame.origin = CGPointZero;
    self.vc_timeline = [[CIEvaluateListVC alloc] initWithFrame:frame Type:EvaluateListItemType_Timeline];
    [self.vc_timeline setDelegate:self];
    [self.view insertSubview:self.vc_timeline.view belowSubview:self.v_tip];
    
    self.vc_myevaluate = [[CIEvaluateListVC alloc] initWithFrame:frame Type:EvaluateListItemType_Self];
    [self.vc_myevaluate setDelegate:self];
    [self.view insertSubview:self.vc_myevaluate.view belowSubview:self.v_tip];
    [self.vc_myevaluate.view setHidden:YES];
    
    
    NSString *phone = [UserDef getUserDefValue:USER_NAME];
    if (phone != nil && phone.length > 0)
    {
        [self.v_tip setHidden:YES];
    }
    else
    {
        [self.vc_timeline.tbv setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
        [self.vc_timeline.tbv setContentOffset:CGPointMake(0, 20)];
        [self.v_tip setHidden:NO];
        [self performSelector:@selector(hideTopTipWithTime) withObject:nil afterDelay:3];
    }
    [self.btn_other setSelected:YES];
    [self.btn_other setImage:[UIImage imageNamed:@"others_news_hover.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    [self.btn_self setImage:[UIImage imageNamed:@"my_news_hover.png"] forState:UIControlStateHighlighted|UIControlStateSelected];
    self.i_timelinePage = 0;
    
    self.loadding = [[HSLoaddingVC alloc] initWithView:self.view
                                                  Type:LOADDING_DEF];
    [self.view addSubview:self.loadding.view];
    [self.loadding hide];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.bIsLogoutBack)
    {
        self.bIsLogoutBack = NO;
        
        [self.btn_other setSelected:YES];
        [self.btn_self setSelected:NO];
        [self.vc_timeline.view setHidden:NO];
        [self.vc_myevaluate.view setHidden:YES];
        
        [self.timeline_datas removeAllObjects];
        [self.trend_datas removeAllObjects];
        self.trend_datas = nil;
        
        CITitleV *v = [[CITitleV alloc] initWithTitle:@"老友说(未验证)"];
        [self.navigationItem setTitleView:v];
        [self.vc_timeline DataLoadStart];
        [self.vc_myevaluate ReloadTableViewWithData:[[NSMutableArray alloc] init]];
    }
    else if ([self.btn_other isSelected])
    {
        NSString *phone = [UserDef getUserDefValue:USER_NAME];
        CITitleV *v = nil;
        if (phone != nil && phone.length > 0)
        {
            v = [[CITitleV alloc] initWithTitle:@"老友说"];
        }
        else
        {
            v = [[CITitleV alloc] initWithTitle:@"老友说(未验证)"];
        }
        [self.navigationItem setTitleView:v];
        
        if (self.bCanLoad && [self.timeline_datas count] == 0)
        {
            [self.vc_timeline DataLoadStart];
        }
    }
    else if (self.bCanLoad && [self.btn_self isSelected] && [self.trend_datas count] == 0)
    {
        [self.vc_myevaluate DataLoadStart];
    }
    
    if (self.bIsLoginBack)
    {
        self.bIsLoginBack = NO;
        ++self.iNeedHideLoad;
        [self.loadding setTipText:@"联系好友中"];
        [self.loadding show];
        //获取用户阅读条数
        NetServiceManager *net = [[NetServiceManager alloc] init];
        self.iUserInfoTag = ++s_tag;
        [net setTag:self.iUserInfoTag];
        [net setDelegate:self];
        [net GetUserInfo:[[NSMutableDictionary alloc] init]];
        [self.nets addObject:net];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getTimeLineData
{
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    [net GetTimeline:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:self.i_timelinePage], CTRL_PAGE, nil]];
    [self.nets addObject:net];
}

-(void)getTrendData
{
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    [net GetTrend:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:self.i_trendPage], CTRL_PAGE, nil]];
    [self.nets addObject:net];
}

-(void)startGetListData
{
    [self HideLoadView];
    
    UIImage *img = [UIImage imageNamed:@"friends.png"];
    UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
    [contact setBackgroundImage:img forState:UIControlStateNormal];
    [contact setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [contact addTarget:self action:@selector(OnFriends:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:contact];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.bCanLoad = YES;
    if ([self.btn_self isSelected])
    {
        [self.vc_myevaluate DataLoadStart];
    }
    else if ([self.btn_other isSelected])
    {
        [self.vc_timeline DataLoadStart];
    }
}

-(void)updateContact
{
    id first = [UserDef getUserDefValue:FIRST_UPLOAD_CONTACT];
    if (first == nil || ![first boolValue])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"我们需要获取您的通讯录才能获取您的老友们的评价，您的通讯录我们将在服务端匿名存储，点击同意继续查看老友们的评论!"
                                                    delegate:self
                                           cancelButtonTitle:@"不同意"
                                           otherButtonTitles:@"同意", nil];
        [av setDelegate:self];
        [av setTag:2];
        [av show];
        return;
    }
    
    if (nil == self.contactData)
    {
        self.contactData = [[CIContactData alloc] init];
        [self.contactData setDelegate:self];
    }
    [self.contactData UpdateData];
    
    if (s_maxReadNum == 0)
    {
        ++self.iNeedHideLoad;
        [self.loadding setTipText:@"联系好友中"];
        [self.loadding show];
        
        //获取用户阅读条数
        NetServiceManager *net = [[NetServiceManager alloc] init];
        self.iUserInfoTag = ++s_tag;
        [net setTag:self.iUserInfoTag];
        [net setDelegate:self];
        [net GetUserInfo:[[NSMutableDictionary alloc] init]];
        [self.nets addObject:net];
    }
}

-(void)OnMore:(id)sender
{
    self.vc_more = nil;
    CIMoreVC *vc = [[CIMoreVC alloc] init];
    [self.navigationController pushViewController:vc
                                   TransitionType:@"push"
                                          SubType:@"fromBottom"];
    [vc setDelegate:self];
    self.vc_more = vc;
}

-(void)OnFriends:(id)sender
{
    CIContactListTVC *vc = [[CIContactListTVC alloc] init];
//    [self.navigationController pushViewController:vc
//                                   TransitionType:@"push"
//                                          SubType:@"fromRight"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)OnMy:(id)sender
{
    NSString *phone = [UserDef getUserDefValue:USER_NAME];
    if (phone == nil || phone.length == 0)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"请先验证手机号，验证手机号后就可以看到您的朋友们对您的评论啦！"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
        [av setTag:1];
        [av show];
    }
    else
    {
        CITitleV *v = [[CITitleV alloc] initWithTitle:@"⽼友对我说"];
        [self.navigationItem setTitleView:v];
        [self.btn_other setSelected:NO];
        [self.btn_self setSelected:YES];
        [self.vc_timeline.view setHidden:YES];
        [self.vc_myevaluate.view setHidden:NO];
        
        if (self.trend_datas == nil)
        {
            self.trend_datas = [[NSMutableArray alloc] init];
            [self getTrendData];
            [self.vc_myevaluate DataLoadStart];
        }
    }
}

-(IBAction)OnFriend:(id)sender
{
    NSString *phone = [UserDef getUserDefValue:USER_NAME];
    CITitleV *v = nil;
    if (phone != nil && phone.length > 0)
    {
        v = [[CITitleV alloc] initWithTitle:@"⽼友正在说"];
    }
    else
    {
        v = [[CITitleV alloc] initWithTitle:@"老友说(未验证)"];
    }
    [self.navigationItem setTitleView:v];
    [self.btn_self setSelected:NO];
    [self.btn_other setSelected:YES];
    [self.vc_myevaluate.view setHidden:YES];
    [self.vc_timeline.view setHidden:NO];
}

-(void)hideTopTipWithTime
{
    [UIView transitionWithView:self.view
                      duration:0.666
                       options:UIViewAnimationOptionLayoutSubviews
                    animations:^{
                        [self.v_tip setHidden:YES];
                        [self.vc_timeline.tbv setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                        [self.vc_timeline.tbv setContentOffset:CGPointMake(0, 0) animated:YES];
                    }
                    completion:^(BOOL finished) {
                    }];
}

-(void)HideLoadView
{
    --self.iNeedHideLoad;
    if (self.iNeedHideLoad <= 0)
    {
        self.iNeedHideLoad = 0;
        [self.loadding hide];
    }
}

-(void)SelectNoEvaluate:(CIEvaluateListVC *)evaluateListVC
{
    [self OnFriends:nil];
}

-(void)SelectEvaluate:(CIEvaluateListVC *)evaluateListVC EvaluateData:(id)data
{
    CIReadEvaluateVC *vc = [[CIReadEvaluateVC alloc] initWithData:data
                                                             Type:evaluateListVC.type];
//    [self.navigationController pushViewController:vc
//                                   TransitionType:@"push"
//                                          SubType:@"fromRight"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ReadEvaluate:(CIEvaluateListVC *)evaluateListVC EvaluateData:(id)data
{
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    [net SetReadEvaluate:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[data objectForKey:CI_TID], CI_TID, nil]];
    [self.nets addObject:net];
}

-(void)RefreshEvaluateList:(CIEvaluateListVC *)evaluateListVC
{
    if (self.vc_timeline == evaluateListVC)
    {
        self.i_timelinePage = 0;
        [self getTimeLineData];
    }
    else if(self.vc_myevaluate == evaluateListVC)
    {
        self.i_trendPage = 0;
        [self getTrendData];
    }
}

-(void)LoadmoreEvaluateList:(CIEvaluateListVC *)evaluateListVC
{
    if (self.vc_timeline == evaluateListVC)
    {
        [self getTimeLineData];
    }
    else if(self.vc_myevaluate == evaluateListVC)
    {
        [self getTrendData];
    }
}

-(void)ScrollUp:(CIEvaluateListVC *)evaluateListVC
{
    [UIView transitionWithView:self.view
                      duration:0.111
                       options:UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        [self.btn_self setAlpha:0.0];
                        [self.btn_other setAlpha:0.0];
                    }
                    completion:^(BOOL finished) {
                    }];
}

-(void)ScrollDown:(CIEvaluateListVC *)evaluateListVC
{
    [UIView transitionWithView:self.view
                      duration:0.111
                       options:UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        [self.btn_self setAlpha:1.0];
                        [self.btn_other setAlpha:1.0];
                    }
                    completion:^(BOOL finished) {
                    }];
}

-(void)CIMoreVC:(CIMoreVC *)vc Logout:(BOOL)bLogout
{
    if (bLogout)
    {
        self.bIsLogoutBack = YES;
    }
}

-(void)CIMoreVC:(CIMoreVC *)vc Login:(BOOL)bLogin
{
    if (bLogin)
    {
        self.bIsLoginBack = YES;
    }
}

/**
 *  弹出框回掉
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        self.bIsShowRelogin = NO;
        if (buttonIndex == 1)
        {
            CILoginVC *vc = [[CILoginVC alloc] init];
            [vc setDelegate:self];
            [self.navigationController pushViewController:vc
                                           TransitionType:@"push"
                                                  SubType:@"fromTop"];
            self.loginVC = vc;
        }
    }
    else if (alertView.tag == 2 && buttonIndex == 0)
    {//用户不同意上传通讯录
        [self.loadding setTipText:@"不同意联系好友"];
        [self.loadding hideAfterDelay:1.0];
        
        [UserDef setUserDefValue:[NSNumber numberWithBool:NO] keyName:FIRST_UPLOAD_CONTACT];
        
        return;
    }
    else if (alertView.tag == 2 && buttonIndex == 1)
    {//用户同意上传通讯录
        [UserDef setUserDefValue:[NSNumber numberWithBool:YES] keyName:FIRST_UPLOAD_CONTACT];
        
        [self updateContact];
    }
}

/**
 *  登录回掉
 */
-(void)LoginResult:(BOOL)success
{
    self.loginVC = nil;
    
    if (success)
    {
        [self getTrendData];
    }
}

/**
 *  通讯录读取完毕
 *
 *  @param count 本次通讯录修改量
 */
-(void)ContactUpdateEnd:(NSInteger)count
{
    if (count > 0)
    {
        ++self.iNeedHideLoad;
        [self.loadding setTipText:@"联系好友中"];
        [self.loadding show];
        
        NetServiceManager *net = [[NetServiceManager alloc] init];
        [net setDelegate:self];
        [net setTag:--s_tagUpload];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (PersonData *d in [CIContactData contacts])
        {
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
            [dic1 setValue:d.phone forKey:CI_PHONES];
            [dic1 setValue:d.name forKey:CI_NAME];
            [dic1 setValue:[NSNumber numberWithInteger:d.pid] forKey:CI_PID];
            [arr addObject:dic1];
        }
        self.phones = arr;
        [dic setValue:arr forKey:CI_CONTACT];
        [net UpdateContacts:dic];
        [self.nets addObject:net];
    }
    else
    {
        [self startGetListData];
    }
}

/**
 *  无通讯录读取权限
 */
-(void)ContactUpdateNoCompetence
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                 message:@"您需要在设置--隐私控制--通讯录里面，同意\"老友说\"访问您的通讯录才能正常使用哦！"
                                                delegate:nil
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil];
    [av show];
}

-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    [self.nets RemoveObjectWithTag:tag];
    [self.vc_timeline DataLoadOver];
    [self.vc_myevaluate DataLoadOver];
    
    if (r == Return_NeedRelogin)
    {//需要重新验证
        if (self.bIsShowRelogin)
        {
            return;
        }
        if (m == nil || m.length == 0)
        {
            m = @"请重新验证手机号码";
        }
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:m
                                                    delegate:nil
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
        [av setTag:1];
        [av setDelegate:self];
        [av show];
        self.bIsShowRelogin = YES;
    }
    else if (tag < 0)
    {
#ifdef DEBUG_TAN
        NSLog(@"上传通讯录：%@", m);
#endif
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * path=[documentsDirectory stringByAppendingPathComponent:@"phones_in_phone"];
        self.phones = [NSArray arrayWithContentsOfFile:path];
        [CIContactData SetContactData:self.phones];
        self.phones = nil;
        [self startGetListData];
    }
    else if (tag == self.iUserInfoTag)
    {
        [self HideLoadView];
        s_maxEvaluateNum = s_maxReadNum = 0;
    }
}

-(void)TimelineData:(id)data Tag:(NSInteger)tag
{
    [self.nets RemoveObjectWithTag:tag];
    NSInteger pg = [[data objectForKey:CTRL_PAGE] integerValue];
    if (pg == self.i_timelinePage)
    {
        id arr = [data objectForKey:CI_LIST];
        if ([arr count] > 0)
        {
            if (self.i_timelinePage == 0)
            {
                [self.timeline_datas removeAllObjects];
            }
            [self.timeline_datas addObjectsFromArray:arr];
            ++self.i_timelinePage;
            [self.vc_timeline ReloadTableViewWithData:self.timeline_datas];
        }
        else
        {
            [self.vc_timeline DataLoadOver];
        }
    }
    else
    {
        [self.vc_timeline DataLoadOver];
    }
}

-(void)TrendData:(id)data Tag:(NSInteger)tag
{
    [self.nets RemoveObjectWithTag:tag];
    NSInteger pg = [[data objectForKey:CTRL_PAGE] integerValue];
    if (pg == self.i_trendPage)
    {
        id arr = [data objectForKey:CI_LIST];
        if ([arr count] > 0)
        {
            if (self.i_trendPage == 0)
            {
                [self.trend_datas removeAllObjects];
            }
            [self.trend_datas addObjectsFromArray:arr];
            ++self.i_trendPage;
            [self.vc_myevaluate ReloadTableViewWithData:self.trend_datas];
        }
        else
        {
            [self.vc_myevaluate DataLoadOver];
        }
    }
    else
    {
        [self.vc_myevaluate DataLoadOver];
    }
}

-(void)SetReadEvaluateData:(id)data Tag:(NSInteger)tag
{
    [self.nets RemoveObjectWithTag:tag];
}

-(void)UpdateContactsData:(id)data Tag:(NSInteger)tag
{
    NSDate *date = [NSDate date];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path=[documentsDirectory stringByAppendingPathComponent:@"phones_in_phone"];
    if (![self.phones writeToFile:path atomically:YES])
    {
        date = [NSDate dateWithTimeIntervalSince1970:0];
    };
    self.phones = nil;
    
    NSString *s = [data objectForKey:CTRL_Session];
    if (![s isEqual:[NSNull null]] && s && s.length > 0)
    {
        [UserDef setUserDefValue:s keyName:USER_SESSION];
    }
    else
    {
        s = [UserDef getUserDefValue:USER_SESSION];
    }
    [UserDef setUserDefValue:date keyName:LASTUPDATE(s)];
    [self startGetListData];
}

-(void)UserInfoData:(id)data Tag:(NSInteger)tag
{
    [self HideLoadView];
    s_maxReadNum = [[data objectForKey:CI_READNUM] integerValue];
    s_maxEvaluateNum = [[data objectForKey:CI_EVLNUM] integerValue];
    
    //归零今日阅读/评论数
    [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_WATCH_Count];
    [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_EVALUATE_Count];
    [UserDef setUserDefValue:[NSDate date] keyName:LAST_WATCH_Date];
}

@end
