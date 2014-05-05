//
//  CIMainListVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-2-20.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIMoreVC.h"
#import "PushViewController+UINavigationController.h"
#import "CIFeedbackVC.h"
#import "HSLoaddingVC.h"

static int s_tag = 0;
extern NSInteger s_maxEvaluateNum;
extern NSInteger s_maxReadNum;

@interface CIMoreVC ()

@property (nonatomic, retain) NSMutableArray *nets;
@property (nonatomic, retain) CILoginVC *vc_login;
@property (nonatomic, retain) HSLoaddingVC *loadding;

@end

@implementation CIMoreVC
@synthesize nets = _nets;
@synthesize vc_login = _vc_login;
@synthesize loadding = _loadding;

- (id)init
{
    self = [super initWithNibName:@"CIMoreVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.nets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES];
    
    NSString *phone = [UserDef getUserDefValue:USER_NAME];
    if (phone == nil || phone.length == 0)
    {
        [(UIButton*)[self.view viewWithTag:10] setBackgroundImage:[UIImage imageNamed:@"checkin.png"]
                                                         forState:UIControlStateNormal];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)OnMore:(id)sender
{
    for (NetServiceManager *net in self.nets)
    {
        [net CancelRequest];
    }
    self.vc_login = nil;
    self.nets = nil;
    [self.navigationController popViewControllerWithTransitionType:@"push"
                                                           SubType:@"fromTop"];
}

-(IBAction)OnGoScore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", APPLE_ID]]];
}

-(IBAction)OnFeedback:(id)sender
{
    CIFeedbackVC *vc = [[CIFeedbackVC alloc] init];
    [self.navigationController pushViewController:vc
                                   TransitionType:@"push"
                                          SubType:@"fromRight"];
}

-(IBAction)OnLogout:(id)sender
{
    NSString *phone = [UserDef getUserDefValue:USER_NAME];
    UIAlertView *vc = nil;
    if (phone && phone.length > 0)
    {//已登录
        vc = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"您确定要退出吗？退出后您可能需要重新验证手机号码！"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
        [vc show];
    }
    else
    {//未登录
        CILoginVC *vc = [[CILoginVC alloc] init];
        [vc setDelegate:self];
        [self.navigationController pushViewController:vc
                                       TransitionType:@"push"
                                              SubType:@"fromTop"];
        self.vc_login = vc;
    }
}

-(void)LoginResult:(BOOL)success
{
    if (success)
    {
        [(UIButton*)[self.view viewWithTag:10] setBackgroundImage:[UIImage imageNamed:@"exit.png"]
                                                         forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(CIMoreVC:Login:)])
        {
            [self.delegate CIMoreVC:self Login:YES];
        }
    }
}

-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    [self.nets RemoveObjectWithTag:tag];
    [self LogoutResetDataWithData:nil];
    if ([self.delegate respondsToSelector:@selector(CIMoreVC:Logout:)])
    {
        //即使网络错误，也返回退出成功
        [self.delegate CIMoreVC:self Logout:YES];
    }
    [self.loadding hide];
    [self.loadding.view removeFromSuperview];
    self.loadding = nil;
    [self OnMore:nil];
}

-(void)LogoutData:(id)data Tag:(NSInteger)tag
{
    [self.nets RemoveObjectWithTag:tag];
    
    [self LogoutResetDataWithData:data];
    if ([self.delegate respondsToSelector:@selector(CIMoreVC:Logout:)])
    {
        [self.delegate CIMoreVC:self Logout:YES];
    }
    [self.loadding hide];
    [self.loadding.view removeFromSuperview];
    self.loadding = nil;
    
    [self OnMore:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {//取消
        return;
    }
    else if (buttonIndex == 1)
    {//确定退出
        self.loadding = [[HSLoaddingVC alloc] initWithView:self.view
                                                      Type:LOADDING_DEF];
        [self.view addSubview:self.loadding.view];
        [self.loadding setTipText:@"退出中"];
        [self.loadding show];
        NetServiceManager *net = [[NetServiceManager alloc] init];
        [net setDelegate:self];
        [net setTag:++s_tag];
        [net Logout:[[NSMutableDictionary alloc] init]];
        [self.nets addObject:net];
    }
}

-(void)LogoutResetDataWithData:(id)data
{
    if (data != nil && [[NSNull null] isEqual:data])
    {
        NSString *s = [data objectForKey:CTRL_Session];
        if (s && s.length > 0)
        {
            //退出登录，修改通讯录id
            [UserDef setUserDefValue:s keyName:USER_SESSION];
            //修改用户的通讯录上传时间为今天
            [UserDef setUserDefValue:[NSDate date] keyName:LASTUPDATE(s)];
        }
    }
    [UserDef setUserDefValue:@"" keyName:USER_NAME];
    //归零今日阅读/评论数
    [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_WATCH_Count];
    [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_EVALUATE_Count];
    [UserDef setUserDefValue:[NSDate date] keyName:LAST_WATCH_Date];
    s_maxReadNum = 0;
    s_maxEvaluateNum = 0;
}
@end
