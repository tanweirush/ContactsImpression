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

@interface CIMoreVC ()

@property (nonatomic, retain) NetServiceManager *net;
@property (nonatomic, retain) CILoginVC *vc_login;

@end

@implementation CIMoreVC
@synthesize net = _net;
@synthesize vc_login = _vc_login;

- (id)init
{
    self = [super initWithNibName:@"CIMoreVC" bundle:nil];
    if (self) {
        // Custom initialization
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
    self.vc_login = nil;
    self.net = nil;
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
    }
}

-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    NSLog(@"%@", m);
}

-(void)VCodeData:(id)data Tag:(NSInteger)tag
{
    NSLog(@"%@", data);
}

-(void)LoginData:(id)data Tag:(NSInteger)tag
{
    NSLog(@"%@", data);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {//取消
        return;
    }
    else if (buttonIndex == 1)
    {//确定退出
        [UserDef setUserDefValue:@"" keyName:USER_NAME];
        [self OnMore:nil];
    }
}
@end
