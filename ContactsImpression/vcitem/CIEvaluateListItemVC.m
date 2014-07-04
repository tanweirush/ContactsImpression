//
//  CIEvaluateListItemVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-4-1.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIEvaluateListItemVC.h"
#import "UserDef.h"
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
        [self.view setBackgroundColor:UIColorFromARGB(0xfff5f5f5)];
        [self.v_tip setBackgroundColor:UIColorFromARGB(0xfff5f5f5)];
        [self.img_arrow setHighlighted:YES];
    }
    [self.lb_tipname setTextColor:UIColorFromARGB(0xffd8d8d8)];
    
    id tmp = [self.data objectForKey:CI_PID];
    NSString *name = @"无名 氏";
    NSString *tipName = @"无名 氏";
    if (tmp)
    {
        name = [CIContactData Pid2Name:[tmp integerValue]];
        tipName = [NSString stringWithFormat:@"有人对%@说，左滑查看", name];
    }
    else
    {
        if (self.type == EvaluateListItemType_Self)
        {
            tipName = @"猜猜好友说了啥，左滑查看";
        }
        else if(self.type == EvaluateListItemType_Friend)
        {
            tipName = @"有人对Ta说，左滑查看";
        }
    }
    [self.lb_tipname setText:tipName];
    
    tmp = [self.data objectForKey:CI_P_NUM];//赞数
    if (tmp)
    {
        [self.lb_p_num setText:[NSString stringWithFormat:@"%@", tmp]];
    }
    else
    {
        [self.lb_p_num setText:@"0"];
    }
    
    tmp = [self.data objectForKey:CI_PRAISE];//是否已赞
    if (tmp && [tmp integerValue] == 1)
    {
        [self.iv_praise setHighlighted:YES];
    }
    
    tmp = [self.data objectForKey:CI_REPLY];//回复数
    if (tmp)
    {
        [self.lb_reply setText:[NSString stringWithFormat:@"%@", tmp]];
    }
    else
    {
        [self.lb_reply setText:@"0"];
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
        else if (second < 3600)
        {//1小时内
            stringFormat = [NSString stringWithFormat:@"%ldmin", (long)second / 60];
        }
        else if (second < 3600 * 24)
        {//24小时内
            stringFormat = [NSString stringWithFormat:@"%ldh", (long)second / 3600];
        }
        else if (second < 3600 * 24 * 7)
        {//一周以内
            stringFormat = [NSString stringWithFormat:@"%ldday", (long)second / 3600 / 24];
        }
        else
        {//1周以上
            df.dateFormat = @"yyyy.MM.dd";
            stringFormat = [df stringFromDate:date];
        }
        [self.lb_time setText:stringFormat];
    }
    else
    {
        [self.lb_time setText:@"未知"];
    }
    
    tmp = [self.data objectForKey:CI_CONTENT];
    if (tmp && [tmp length] > 0)
    {
        if (self.type == EvaluateListItemType_Timeline)
        {
            [self.lb_content setText:[NSString stringWithFormat:@"%@，%@", name, tmp]];
        }
        else
        {
            [self.lb_content setText:tmp];
        }
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
