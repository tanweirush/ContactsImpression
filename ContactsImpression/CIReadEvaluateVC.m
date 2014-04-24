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

@interface CIReadEvaluateVC ()

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, assign) EvaluateListItemType type;

@end

@implementation CIReadEvaluateVC
@synthesize data = _data;

- (id)initWithData:(id)data Type:(EvaluateListItemType)type
{
    self = [super initWithNibName:@"CIReadEvaluateVC" bundle:nil];
    if (self) {
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
    
    [self.tv setText:[self.data objectForKey:CI_CONTENT]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnBack:(id)sender
{
//    [self.navigationController popViewControllerWithTransitionType:@"push"
//                                                           SubType:@"fromLeft"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
