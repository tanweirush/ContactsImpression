//
//  CILoginVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-26.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CILoginVC.h"
#import "PushViewController+UINavigationController.h"
#import "CITitleV.h"
#import "HSLoaddingVC.h"

static int s_tag = 0;
extern NSInteger s_maxEvaluateNum;
extern NSInteger s_maxReadNum;

@interface CILoginVC ()

@property (nonatomic, retain) HSLoaddingVC *loadding;
@property (nonatomic, retain) NSMutableArray *nets;

@end

@implementation CILoginVC
@synthesize loadding = _loadding;
@synthesize nets = _nets;

- (id)init
{
    self = [super initWithNibName:@"CILoginVC" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *img = [UIImage imageNamed:@"back1.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [button addTarget:self action:@selector(OnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    CITitleV *title = [[CITitleV alloc] initWithTitle:@"填个手机号码"];
    [self.navigationItem setTitleView:title];
    
    [self.tf_phone setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)]];
    [self.tf_phone setLeftViewMode:UITextFieldViewModeAlways];
    
    img = [UIImage imageNamed:@"goto_sign.png"];
    img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    [self.btn_login setBackgroundImage:img forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (NetServiceManager *net in self.nets)
    {
        [net CancelRequest];
    }
}

-(void)initData
{
    if (self.loadding == nil)
    {
        self.loadding = [[HSLoaddingVC alloc] initWithView:self.view
                                                      Type:LOADDING_DEF];
        [self.view addSubview:self.loadding.view];
    }
    if (self.nets == nil)
    {
        self.nets = [[NSMutableArray alloc] init];
    }
}

-(void)OnBack:(id)sender
{
    for (NetServiceManager *net in self.nets)
    {
        [net CancelRequest];
    }
    [self.nets removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(LoginResult:)])
    {
        [self.delegate LoginResult:NO];
    }
    [self.navigationController popViewControllerWithTransitionType:@"push"
                                                           SubType:@"fromBottom"];
}

-(IBAction)OnLogin:(id)sender
{
    if (self.tf_phone.text.length < 11)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"您要输入11位手机号码哦！"
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    
    [self.tf_phone resignFirstResponder];
    [self initData];
    [self.loadding setTipText:@"验证中"];
    [self.loadding show];
    
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    [net LoginWithUserName:self.tf_phone.text
                  Password:@"0571"];
    [self.nets addObject:net];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *s = [textField.text stringByReplacingCharactersInRange:range
                                                          withString:string];
    
    if (textField.tag == self.tf_phone.tag && s.length > 11)
    {
        return FALSE;
    }
    return TRUE;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return FALSE;
}

-(void)EnableSendVcode
{
    [(UIButton*)[self.view viewWithTag:3000] setEnabled:YES];
}

-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    [self.nets RemoveObjectWithTag:tag];
    [self EnableSendVcode];
    
    if (m && m.length > 0)
    {
        [self.loadding setTipText:m];
    }
    else
    {
        [self.loadding setTipText:@"网络太慢啦"];
    }
    [self.loadding hideAfterDelay:1.5];
}

-(void)LoginData:(id)data Tag:(NSInteger)tag
{
    NSLog(@"LoginData :\n%@", data);
    [self.nets RemoveObjectWithTag:tag];
    
    NSString *s = [data objectForKey:CTRL_Session];
    [UserDef setUserDefValue:s keyName:USER_SESSION];
    //修改用户的通讯录上传时间为今天
    [UserDef setUserDefValue:[NSDate date] keyName:LASTUPDATE(s)];
    
    //获取用户阅读条数
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setTag:++s_tag];
    [net setDelegate:self];
    [net GetUserInfo:[[NSMutableDictionary alloc] init]];
    [self.nets addObject:net];
}

-(void)UserInfoData:(id)data Tag:(NSInteger)tag
{
    [self.nets RemoveObjectWithTag:tag];
    [self.loadding setTipText:@"尽情玩耍吧"];
    [self.loadding hideAfterDelay:1.5];
    
    s_maxReadNum = [[data objectForKey:CI_READNUM] integerValue];
    s_maxEvaluateNum = [[data objectForKey:CI_EVLNUM] integerValue];
    
    //归零今日阅读/评论数
//    [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_WATCH_Count];
//    [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_EVALUATE_Count];
//    [UserDef setUserDefValue:[NSDate date] keyName:LAST_WATCH_Date];
    
    if ([self.delegate respondsToSelector:@selector(LoginResult:)])
    {
        [self.delegate LoginResult:YES];
    }
    [self.navigationController popViewControllerWithTransitionType:@"push"
                                                           SubType:@"fromBottom"];
}
@end
