//
//  CIReadEvaluateVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-4-2.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIReadEvaluateVC.h"
#import "PushViewController+UINavigationController.h"
#import "CITitleV.h"
#import "CIContactData.h"
#import "CIReplyEvaluateListVC.h"

@interface CIReadEvaluateVC ()

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, assign) EvaluateListItemType type;
@property (nonatomic, retain) NetServiceManager *net;
@property (nonatomic, retain) CIReplyEvaluateListVC *vc_reply;
@property (nonatomic, retain) CISetEvaluateVC *vc_evaluate;

@end

@implementation CIReadEvaluateVC
@synthesize data = _data;

- (id)initWithData:(id)data Type:(EvaluateListItemType)type
{
    self = [super initWithNibName:@"CIReadEvaluateVC" bundle:nil];
    if (self)
    {
        // Custom initialization
        self.data = data;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *name = @"";
    if ([self.data objectForKey:CI_PID] == nil)
    {
        if (self.type == EvaluateListItemType_Friend)
        {
            name = @"TA的老友说TA";
        }
        else if (self.type == EvaluateListItemType_Self)
        {
            name = @"你的老友说你";
        }
    }
    else
    {
        name = [CIContactData Pid2Name:[[self.data objectForKey:CI_PID] integerValue]];
    }
    CITitleV *title = [[CITitleV alloc] initWithTitle:name];
    [self.navigationItem setTitleView:title];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack setImageEdgeInsets:UIEdgeInsetsMake(0, -(44 - 5), 0, 0)];
    [btnBack addTarget:self action:@selector(OnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self.lb_content setText:[self.data objectForKey:CI_CONTENT]];
    
    self.vc_reply = [[CIReplyEvaluateListVC alloc] initWithData:self.data];
    [self.view addSubview:self.vc_reply.view];
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:[self.data objectForKey:CI_TID] forKey:CI_TID];
//    [dic setValue:[NSNumber numberWithInteger:0] forKey:CTRL_PAGE];
//    self.net = [[NetServiceManager alloc] init];
//    [self.net setDelegate:self];
//    [self.net GetReplyList:dic];
    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:[self.data objectForKey:CI_TID] forKey:CI_TID];
//    [dic setValue:@"呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵" forKey:CI_CONTENT];
//    self.net = [[NetServiceManager alloc] init];
//    [self.net setDelegate:self];
//    [self.net SetReplyForTimeline:dic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.iv_praise setAlpha:0.0];
    
    if ([[self.data objectForKey:CI_PRAISE] integerValue] == 1)
    {
        [self.btn_praise setSelected:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y = self.v_tool.frame.origin.y + self.v_tool.frame.size.height + 10;
    rect.size.height -= rect.origin.y + 64 + 10;
    [self.vc_reply.view setFrame:rect];
}

-(void)OnBack:(id)sender
{
//    [self.navigationController popViewControllerWithTransitionType:@"push"
//                                                           SubType:@"fromLeft"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)OnPraise:(id)sender
{
    if (![self.btn_praise isSelected])
    {
        [self.btn_praise setSelected:YES];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[self.data objectForKey:CI_TID] forKey:CI_TID];
        self.net = [[NetServiceManager alloc] init];
        [self.net setDelegate:self];
        [self.net SetPraiseForTimeline:dic];
    }
    
    /**
     *  赞图标闪现
     */
    [UIView transitionWithView:self.iv_praise
                      duration:0.111
                       options:UIViewAnimationOptionLayoutSubviews
                    animations:^{
                        [self.iv_praise setAlpha:0.666];
                    }
                    completion:^(BOOL finished) {
                        [UIView transitionWithView:self.iv_praise
                                          duration:0.222
                                           options:UIViewAnimationOptionLayoutSubviews
                                        animations:^{
                                            [self.iv_praise setAlpha:0.0];
                                        }
                                        completion:^(BOOL finished) {
                                            
                                        }];
                    }];
}

-(IBAction)OnReply:(id)sender
{
    CISetEvaluateVC *vc = [[CISetEvaluateVC alloc] initWithData:self.data
                                                           Type:CISetEvaluateType_Reply];
    self.vc_evaluate = vc;
    [self.vc_evaluate setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString *)m Result:(NSInteger)r
{
    self.net = nil;
}

-(void)SetPraiseData:(id)data Tag:(NSInteger)tag
{
    self.net = nil;
}

-(void)SetEvaluate:(CISetEvaluateVC *)vc Data:(id)data
{
    [self.vc_reply addReply:data];
}
@end
