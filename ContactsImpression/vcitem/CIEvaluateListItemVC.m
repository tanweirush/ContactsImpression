//
//  CIEvaluateListItemVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-4-1.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIEvaluateListItemVC.h"
#import "CIContactData.h"

@interface CIEvaluateListItemVC ()

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) EvaluateListItemType type;

@end

@implementation CIEvaluateListItemVC
@synthesize type = _type;
@synthesize index = _index;
@synthesize data = _data;

- (id)initWithData:(id)data Type:(EvaluateListItemType)type Index:(NSInteger)index
{
    self = [super initWithNibName:@"CIEvaluateListItemVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.index = index;
        self.data = data;
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.index % 2) {
        [self.view setBackgroundColor:UIColorFromARGB(0xffffffff)];
        [self.v_tip setBackgroundColor:UIColorFromARGB(0xffffffff)];
    }
    else
    {
        [self.view setBackgroundColor:UIColorFromARGB(0xfff6f6f6)];
        [self.v_tip setBackgroundColor:UIColorFromARGB(0xfff6f6f6)];
        [self.img_arrow setHighlighted:YES];
    }
    [self.lb_tipname setTextColor:UIColorFromARGB(0xffd8d8d8)];
    [self.lb_tipstar setTextColor:UIColorFromARGB(0xffd8d8d8)];
    [self.lb_tiptime setTextColor:UIColorFromARGB(0xffd8d8d8)];
    
    id tmp = [self.data objectForKey:CI_PID];
    if (tmp)
    {
        NSString *name = [CIContactData Pid2Name:[tmp integerValue]];
        [self.lb_name setText:name];
        [self.lb_tipname setText:name];
    }
    else
    {
        if (self.type == EvaluateListItemType_Self)
        {
            [self.lb_name setText:@"你"];
            [self.lb_tipname setText:@"你"];
        }
        else if(self.type == EvaluateListItemType_Friend)
        {
            [self.lb_name setText:@"老友"];
            [self.lb_tipname setText:@"老友"];
        }
        else
        {
            [self.lb_name setText:@"无名 氏"];
            [self.lb_tipname setText:@"无名 氏"];
        }
    }
    
    tmp = [self.data objectForKey:CI_STAR];
    if (tmp)
    {
        [self.lb_star setText:[NSString stringWithFormat:@"%@", tmp]];
        [self.lb_tipstar setText:[NSString stringWithFormat:@"被评%@分，左滑查看", tmp]];
    }
    else
    {
        [self.lb_star setText:@"4"];
        [self.lb_tipstar setText:@"被评4分，左滑查看"];
    }
    
    tmp = [self.data objectForKey:CI_TIME];
    if (tmp && [tmp length] > 0)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [df dateFromString:tmp];
        
        NSString *stringFormat = @"";
        NSInteger second = ([NSDate date].timeIntervalSince1970 - date.timeIntervalSince1970);
        if (second < 60)
        {//1分钟内
            stringFormat = [NSString stringWithFormat:@"%lds", (long)second];
        }
        else if (second < 60 * 60)
        {//1小时内
            stringFormat = [NSString stringWithFormat:@"%ldmin", (long)second / 60];
        }
        else if (second < 60 * 60 * 24)
        {//24小时内
            stringFormat = [NSString stringWithFormat:@"%ldh", (long)second / 60 / 24];
        }
        else if (second < 60 * 60 * 24 * 24 * 7)
        {//一周以内
            stringFormat = [NSString stringWithFormat:@"%ldday", (long)second / 60 / 24 / 24];
        }
        else
        {
            stringFormat = tmp;
        }
        [self.lb_time setText:stringFormat];
        [self.lb_tiptime setText:stringFormat];
    }
    else
    {
        [self.lb_time setText:@"未知"];
        [self.lb_tiptime setText:@""];
    }
    
    tmp = [self.data objectForKey:CI_CONTENT];
    if (tmp && [tmp length] > 0)
    {
        [self.lb_content setText:tmp];
    }
    else
    {
        [self.lb_content setText:@""];
    }
    
    tmp = [self.data objectForKey:CI_READ];
    if (tmp && [tmp integerValue] == 1)
    {
        [self.v_tip setHidden:YES];
    }
    else
    {
        [self.v_tip setHidden:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
