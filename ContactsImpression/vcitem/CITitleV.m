//
//  CITitleV.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-24.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CITitleV.h"
#define TITLE_W 180

@implementation CITitleV

- (id)initWithTitle:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, 0, TITLE_W, 44)];
    if (self) {
        // Initialization code
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_W, 44)];
        [t setTextColor:UIColorFromARGB(0xffffffff)];
        [t setTextAlignment:NSTextAlignmentCenter];
        [t setFont:[UIFont systemFontOfSize:20.0f]];
        [t setText:title];
        [self addSubview:t];
        self.title = t;
        [self setBackgroundColor:UIColorFromARGB(0x0)];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
