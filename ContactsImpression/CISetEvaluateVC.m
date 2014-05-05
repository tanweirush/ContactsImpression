//
//  CISetEvaluateVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-31.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CISetEvaluateVC.h"
#import "PushViewController+UINavigationController.h"
#import "PersonData.h"
#import "CITitleV.h"
#import "HSLoaddingVC.h"
#import "CILoginVC.h"

extern int s_maxEvaluateNum;

@interface CISetEvaluateVC ()

@property (nonatomic, retain) PersonData *personData;
@property (nonatomic, retain) NetServiceManager *net;
@property (nonatomic, retain) HSLoaddingVC *loadding;
@property (nonatomic, assign) NSInteger star;

@end

@implementation CISetEvaluateVC
@synthesize personData = _personData;
@synthesize net = _net;
@synthesize loadding = _loadding;
@synthesize star = _star;

- (id)initWithData:(id)data
{
    self = [super initWithNibName:@"CISetEvaluateVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.personData = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *name = self.personData.name;
    if (name.length == 0)
    {
        name = [self.personData.phone objectAtIndex:0];
    }
    CITitleV *title = [[CITitleV alloc] initWithTitle:[NSString stringWithFormat:@"说%@", name]];
    [self.navigationItem setTitleView:title];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack setImageEdgeInsets:UIEdgeInsetsMake(0, -(44 - 5), 0, 0)];
    [btnBack addTarget:self action:@selector(OnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOK setFrame:CGRectMake(0, 0, 44, 44)];
    [btnOK setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [btnOK setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(44 - 10))];
    [btnOK addTarget:self action:@selector(OnOK:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *OKItem = [[UIBarButtonItem alloc] initWithCustomView:btnOK];
    self.navigationItem.rightBarButtonItem = OKItem;
    
    self.tv_evaluate.layer.cornerRadius = 5;
    self.tv_evaluate.layer.borderColor = UIColorFromARGB(0xffc8c8c8).CGColor;
    self.tv_evaluate.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.loadding = nil;
    self.net = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.star = 4;
    for (NSInteger i = 1; i <= self.star; ++i)
    {
        [(UIButton*)[self.view viewWithTag:i] setSelected:YES];
    }
    
    NSInteger count = [[UserDef getUserDefValue:LAST_EVALUATE_Count] integerValue];
    NSString *phone = [UserDef getUserDefValue:USER_NAME];
    if (phone == nil || phone.length == 0)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"您还没有验证手机号码，验证手机号码后就可以评论您的老友啦！"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
        [av setTag:1];
        [av show];
    }
    else if (count >= s_maxEvaluateNum)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"今天已经说的太多啦，明天再来哦！"
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av setDelegate:self];
        [av setTag:2];
        [av show];
        return;
    }
    else
    {
        [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.333];
    }
}

-(void)OnBack:(id)sender
{
    self.personData = nil;
    self.net = nil;
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popViewControllerWithTransitionType:@"push" SubType:@"fromLeft"];

}

-(void)OnOK:(id)sender
{
    if (self.tv_evaluate.text.length == 0)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"对你的老友，说点啥呗！"
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    
    [self.tv_evaluate resignFirstResponder];
    if (self.loadding == nil)
    {
        self.loadding = [[HSLoaddingVC alloc] initWithView:self.view Type:LOADDING_DEF];
        [self.view addSubview:self.loadding.view];
    }
    [self.loadding setTipText:@"让点评⻜一会儿"];
    [self.loadding show];
    
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.tv_evaluate.text forKey:CI_CONTENT];
    [dic setValue:[NSNumber numberWithInteger:self.personData.pid] forKey:CI_PID];
    [dic setValue:[NSNumber numberWithInteger:self.star] forKey:CI_STAR];
    
    [net SetEvaluate:dic];
    self.net = net;
}

-(IBAction)OnSelectStar:(id)sender
{
    self.star = [sender tag];
    for (NSInteger i = 1; i <= self.star; ++i)
    {
        [(UIButton*)[self.view viewWithTag:i] setSelected:YES];
    }
    for (NSInteger i = self.star + 1; i <= 5; ++i)
    {
        [(UIButton*)[self.view viewWithTag:i] setSelected:NO];
    }
}

-(BOOL)             textView:(UITextView *)textView
     shouldChangeTextInRange:(NSRange)range
             replacementText:(NSString *)text
{
    NSString *textReplace = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (textReplace.length < text.length)
    {
        [self OnOK:nil];
        return FALSE;
    }
    NSString *s = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (s.length > 255)
    {
        return FALSE;
    }
    return TRUE;
}

-(void)showKeyboard
{
    [self.tv_evaluate becomeFirstResponder];
}

/**
 *  弹出框回掉
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1)
    {
        CILoginVC *vc = [[CILoginVC alloc] init];
        [self.navigationController pushViewController:vc
                                       TransitionType:@"push"
                                              SubType:@"fromTop"];
    }
    else if ((alertView.tag == 1 || alertView.tag == 2) && buttonIndex == 0)
    {
//        [self.navigationController popViewControllerWithTransitionType:@"push"
//                                                               SubType:@"fromLeft"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 0x8001 && buttonIndex == 0)
    {
        CILoginVC *vc = [[CILoginVC alloc] init];
        [self.navigationController pushViewController:vc
                                       TransitionType:@"push"
                                              SubType:@"fromTop"];
    }
}

-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    self.net = nil;
    if (m && m.length > 0)
    {
        [self.loadding hide];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:m
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        
        if (r == Return_NeedRelogin)
        {//需要重新验证
            [av setDelegate:self];
            [av setTag:0x8001];
            return;
        }
        [av show];
    }
    else
    {
        [self.loadding setTipText:@"网络抽疯啦"];
        [self.loadding hideAfterDelay:1.5];
    }
}

-(void)SetEvaluateData:(id)data Tag:(NSInteger)tag
{
    self.net = nil;
    [self.loadding hide];
    
    if ([self.delegate respondsToSelector:@selector(SetEvaluate:Data:)])
    {
        [self.delegate SetEvaluate:self Data:data];
    }
    
    NSInteger count = [[UserDef getUserDefValue:LAST_EVALUATE_Count] integerValue];
    if (count == 0)
    {
        NSInteger watch = [[UserDef getUserDefValue:LAST_WATCH_Count] integerValue];
        [UserDef setUserDefValue:[NSNumber numberWithInteger:--watch] keyName:LAST_WATCH_Count];
    }
    [UserDef setUserDefValue:[NSNumber numberWithInteger:++count] keyName:LAST_EVALUATE_Count];
    
    [self OnBack:nil];
}
@end
