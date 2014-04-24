//
//  CINoEvaluateItemVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-4-3.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CINoEvaluateItemVC.h"

@interface CINoEvaluateItemVC ()

@property (nonatomic, copy) NSString *tip;

@end

@implementation CINoEvaluateItemVC

- (id)initWithTip:(NSString*)tip
{
    self = [super initWithNibName:@"CINoEvaluateItemVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.tip = tip;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.lb_tip setText:self.tip];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
