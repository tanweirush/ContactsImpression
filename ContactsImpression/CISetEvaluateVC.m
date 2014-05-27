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

#define Reply_Text @"回复"
#define TimeLine_Text @"匿名对TA进行点评、爆糗、调侃、抱怨、还是表白，老友说，说什么都可以！"

@interface CISetEvaluateVC ()

@property (nonatomic, retain) PersonData *personData;
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) NetServiceManager *net;
@property (nonatomic, retain) HSLoaddingVC *loadding;
@property (nonatomic, assign) CISetEvaluateType type;

@end

@implementation CISetEvaluateVC
@synthesize personData = _personData;
@synthesize net = _net;
@synthesize loadding = _loadding;

- (id)initWithData:(id)data Type:(CISetEvaluateType)type
{
    self = [super initWithNibName:@"CISetEvaluateVC" bundle:nil];
    if (self) {
        // Custom initialization
        if (type == CISetEvaluateType_Reply)
        {
            self.data = data;
        }
        else if (type == CISetEvaluateType_Timeline)
        {
            self.personData = data;
        }
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.type == CISetEvaluateType_Timeline)
    {
        NSString *name = self.personData.name;
        if (name.length == 0)
        {
            name = [self.personData.phone objectAtIndex:0];
        }
        CITitleV *title = [[CITitleV alloc] initWithTitle:[NSString stringWithFormat:@"说%@", name]];
        [self.navigationItem setTitleView:title];
    }
    else if (self.type == CISetEvaluateType_Reply)
    {
        CITitleV *title = [[CITitleV alloc] initWithTitle:@"回复"];
        [self.navigationItem setTitleView:title];
    }
    [self.tv_evaluate addSubview:self.lb_tip];
    [self.lb_tip setFrame:CGRectMake(5, 5, 280, self.lb_tip.frame.size.height)];
    
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
    if (self.type == CISetEvaluateType_Timeline)
    {
        [self.lb_tip setText:TimeLine_Text];
        NSInteger count = [[UserDef getUserDefValue:LAST_EVALUATE_Count] integerValue];
        NSString *phone = [UserDef getUserDefValue:USER_NAME];
        if (count >= s_maxEvaluateNum)
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
            for (NSString *p in self.personData.phone)
            {
                if ([phone isEqualToString:p])
                {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"你赖皮哦，不能评价自己！"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                    [av setDelegate:self];
                    [av setTag:2];
                    [av show];
                    return;
                }
            }
        }
//        [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.333];
    }
    else if (self.type == CISetEvaluateType_Reply)
    {
        [self.lb_tip setText:Reply_Text];
    }
    [self.lb_tip sizeToFit];
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
    if (self.type == CISetEvaluateType_Timeline)
    {
        [self SendTimeline];
    }
    else if (self.type == CISetEvaluateType_Reply)
    {
        [self SendReply];
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.lb_tip setHidden:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        [self.lb_tip setHidden:NO];
    }
}

-(void)showKeyboard
{
    [self.tv_evaluate becomeFirstResponder];
}

-(void)SendTimeline
{
    if (self.tv_evaluate.text.length == 0)
    {
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
    
    [net SetEvaluate:dic];
    self.net = net;
}

-(void)SendReply
{
    if (self.tv_evaluate.text.length == 0)
    {
        return;
    }
    
    [self.tv_evaluate resignFirstResponder];
    if (self.loadding == nil)
    {
        self.loadding = [[HSLoaddingVC alloc] initWithView:self.view Type:LOADDING_DEF];
        [self.view addSubview:self.loadding.view];
    }
    [self.loadding setTipText:@"让回复⻜一会儿"];
    [self.loadding show];
    
    NetServiceManager *net = [[NetServiceManager alloc] init];
    [net setDelegate:self];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.tv_evaluate.text forKey:CI_CONTENT];
    [dic setValue:[self.data objectForKey:CI_TID] forKey:CI_TID];
    
    [net SetReplyForTimeline:dic];
    self.net = net;
}

/**
 *  弹出框回掉
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1 || alertView.tag == 2) && buttonIndex == 0)
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
        [self.loadding setTipText:m];
        [self.loadding hideAfterDelay:1.5];
    }
    else
    {
        [self.loadding setTipText:@"没飞起来，您重试一下吧"];
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
    if (count < 3)
    {
        NSInteger watch = [[UserDef getUserDefValue:LAST_WATCH_Count] integerValue];
        [UserDef setUserDefValue:[NSNumber numberWithInteger:--watch] keyName:LAST_WATCH_Count];
    }
    [UserDef setUserDefValue:[NSNumber numberWithInteger:++count] keyName:LAST_EVALUATE_Count];
    
    [self OnBack:nil];
}

-(void)ReplyTimeLineData:(id)data Tag:(NSInteger)tag
{
    self.net = nil;
    [self.loadding hide];
    
    if ([self.delegate respondsToSelector:@selector(SetEvaluate:Data:)])
    {
        [self.delegate SetEvaluate:self Data:self.tv_evaluate.text];
    }
    [self OnBack:nil];
}
@end
