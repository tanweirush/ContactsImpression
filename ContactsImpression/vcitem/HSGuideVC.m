//
//  HSGuideVC.m
//  HotelSupplies
//
//  Created by 谭伟 on 13-11-15.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import "HSGuideVC.h"
#import "sys/utsname.h"

@interface HSGuideVC ()

@end

@implementation HSGuideVC

- (id)init
{
    self = [super initWithNibName:@"HSGuideVC" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.s
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    int count = 0;
    while (YES)
    {
        NSString *file = [NSString stringWithFormat:@"page_%d.png", count];
        UIImage *img = [UIImage imageNamed:file];
        if (!img) {
            break;
        }
        CGRect rt = CGRectMake(count * size.width, 0,
                               size.width,
                               size.height);
        UIImageView *iv = [[UIImageView alloc] initWithFrame:rt];
        [iv setImage:img];
        
        [self.sv_root insertSubview:iv atIndex:0];
        
        ++count;
    }
    
    [self.sv_root setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.view setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.sv_root setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.sv_root setContentSize:CGSizeMake(count * size.width, size.height)];
    CGRect rt = self.btn.frame;
    rt.origin.x = rt.origin.x + (count - 1)*size.width;
    rt.origin.y = size.height - 40 - self.btn.frame.size.height;
    [self.btn setFrame:rt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(IBAction)OnStart:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(HSGuideVC:Start:)])
    {
        [self.delegate HSGuideVC:self Start:YES];
    }
}

- (NSString*)getDeviceModelAndSysVersion
{
    //here use sys/utsname.h
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    //get the device model
    
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *version =    [[UIDevice currentDevice] systemVersion];
    
    return model;
}
@end
