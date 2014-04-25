//
//  SHLoaddingVC.m
//  SwanHotel
//
//  Created by 谭伟 on 13-7-26.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HSLoaddingVC.h"

@interface HSLoaddingVC ()

@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) UIView *parentView;
@property (nonatomic, assign) LOADDING_TYPE type;

@end

@implementation HSLoaddingVC
@synthesize parentView = _parentView;
@synthesize type = _type;
@synthesize images = _images;

- (id)initWithView:(UIView*)view
{
    self = [super initWithNibName:@"HSLoaddingVC_full" bundle:nil];
    if (self) {
        // Custom initialization
        self.type = LOADDING_FULL;
        self.parentView = view;
        self.images = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 2; ++i)
        {
            NSString *imgName = [NSString stringWithFormat:@"load_10%02d.png", i];
            UIImage *img = [UIImage imageNamed:imgName];
            [self.images addObject:img];
        }
    }
    return self;
}

- (id)initWithView:(UIView*)view Type:(LOADDING_TYPE)type
{
    if (type == LOADDING_DEF)
    {
        self = [super initWithNibName:@"HSLoaddingVC_def" bundle:nil];
    }
    else if (type == LOADDING_FULL)
    {
        self = [super initWithNibName:@"HSLoaddingVC_full" bundle:nil];
    }
    if (self) {
        // Custom initialization
        self.parentView = view;
        self.type = type;
        
        self.images = [[NSMutableArray alloc] init];
        if (type == LOADDING_DEF)
        {
            for (int i = 1; i <= 75; ++i)
            {
                NSString *imgName = [NSString stringWithFormat:@"load_0%02d.png", i];
                UIImage *img = [UIImage imageNamed:imgName];
                [self.images addObject:img];
            }
        }
        else if (type == LOADDING_FULL)
        {
            for (int i = 1; i <= 2; ++i)
            {
                NSString *imgName = [NSString stringWithFormat:@"load_10%02d.png", i];
                UIImage *img = [UIImage imageNamed:imgName];
                [self.images addObject:img];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    if (self.type == LOADDING_FULL)
    {
        [self.view setFrame:CGRectMake(0, 64, size.width, size.height - 64)];
        self.view3.animationImages = self.images;
        [self.view3 setAnimationDuration:0.2f];
        [self.view3 setAnimationRepeatCount:0];
        [self.view setBackgroundColor:UIColorFromARGB(0xffffffff)];
    }
    else
    {
        [self.view setFrame:CGRectMake(0, 0, size.width, size.height)];
        self.view3.animationImages = self.images;
        [self.view3 setAnimationDuration:5.0f];
        [self.view3 setAnimationRepeatCount:0];
        [self.view setBackgroundColor:UIColorFromARGB(0x22000000)];
        self.view2.layer.cornerRadius = 20;
    }
    
    [self hide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show
{
    [self.view setHidden:NO];
    [self.view3 startAnimating];
    [self.view1 setHidden:NO];
    [self.view3 setHidden:NO];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    if (self.type == LOADDING_FULL)
    {
        [self.view setFrame:CGRectMake(0, 64, size.width, size.height - 64)];
    }
    else
    {
        [self.view setFrame:CGRectMake(0, 0, size.width, size.height)];
    }
}

-(void)hide
{
    [self.view1 setHidden:YES];
    [self.view3 setHidden:YES];
    [self.view setHidden:YES];
}

-(void)hideAfterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

-(void)setTipText:(NSString *)title
{
    [self.view1 setText:title];
    CGRect rt = self.view1.frame;
    rt.size.width = 142;
    [self.view1 setFrame:rt];
    [self.view1 sizeToFit];
    [self.view1 setCenter:CGPointMake(self.view3.center.x, self.view1.center.y)];
    
    rt = self.view2.frame;
    rt.size.height = self.view1.frame.origin.y + self.view1.frame.size.height - rt.origin.y + 15;
    [self.view2 setFrame:rt];
    
}

@end
