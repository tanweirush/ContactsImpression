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
    
    CITitleV *title = [[CITitleV alloc] initWithTitle:@"验证手机号码"];
    [self.navigationItem setTitleView:title];
    
    [self.tf_phone setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)]];
    [self.tf_phone setLeftViewMode:UITextFieldViewModeAlways];
    
    [self.tf_vcode setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)]];
    [self.tf_vcode setLeftViewMode:UITextFieldViewModeAlways];
    
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

-(IBAction)OnSendVCode:(id)sender
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
    [self.tf_vcode resignFirstResponder];
    [self initData];
    [sender setEnabled:NO];
    [self.loadding setTipText:@"发送中"];
    [self.loadding show];
    
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    [net GetVCode:[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.tf_phone.text, POST_USERNAME, nil]];
    [self.nets addObject:net];
    
    [self performSelector:@selector(EnableSendVcode) withObject:nil afterDelay:20.0f];
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
    else if (self.tf_vcode.text.length < 4)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"您要输入4位验证码哦！"
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    
    [self.tf_phone resignFirstResponder];
    [self.tf_vcode resignFirstResponder];
    [self initData];
    [self.loadding setTipText:@"验证中"];
    [self.loadding show];
    
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    [net setTag:++s_tag];
    [net LoginWithUserName:self.tf_phone.text
                  Password:self.tf_vcode.text];
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
    else if (textField.tag == self.tf_vcode.tag && s.length > 4)
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

-(void)VCodeData:(id)data Tag:(NSInteger)tag
{
    NSLog(@"VCodeData :\n%@", data);
    [self.nets RemoveObjectWithTag:tag];
    [self.loadding setTipText:@"注意查收短信哦"];
    [self.loadding hideAfterDelay:1.5];
}

-(void)LoginData:(id)data Tag:(NSInteger)tag
{
    NSLog(@"LoginData :\n%@", data);
    [self.nets RemoveObjectWithTag:tag];
    [self.loadding setTipText:@"验证成功啦"];
    [self.loadding hideAfterDelay:1.5];
    
    NSString *s = [data objectForKey:CTRL_Session];
    [UserDef setUserDefValue:s keyName:USER_SESSION];
    
    if ([self.delegate respondsToSelector:@selector(LoginResult:)])
    {
        [self.delegate LoginResult:YES];
    }
    
    [self OnBack:nil];
}
@end