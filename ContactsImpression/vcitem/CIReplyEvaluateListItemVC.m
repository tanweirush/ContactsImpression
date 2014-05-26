//
//  CIReplyEvaluateListItemVC.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-5-24.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIReplyEvaluateListItemVC.h"

const int bottom = 0;

@interface CIReplyEvaluateListItemVC ()

@property (nonatomic, retain) NSString *reply;
@property (nonatomic, assign) NSInteger index;

@end

@implementation CIReplyEvaluateListItemVC

- (id)initWithReply:(NSString*)reply Index:(NSInteger)index
{
    self = [super initWithNibName:@"CIReplyEvaluateListItemVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.reply = reply;
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.lb_floor setText:[NSString stringWithFormat:@"# %ld", (long)self.index + 1]];
    [self.lb_reply setText:self.reply];
    [self.lb_reply sizeToFit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 0, 320,
                                   self.lb_reply.frame.origin.y + self.lb_reply.frame.size.height + bottom)];
}

+(CGFloat)LabelHeighWithText:(NSString*)text
{
    CGSize titleSize = [text sizeWithFont:[UIFont systemFontOfSize:15]
                        constrainedToSize:CGSizeMake(227, MAXFLOAT)
                            lineBreakMode:NSLineBreakByWordWrapping];
    return titleSize.height + 15 + bottom;
}
@end
