//
//  SHLoaddingVC.h
//  SwanHotel
//
//  Created by 谭伟 on 13-7-26.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, LOADDING_TYPE)
{
    /**
     *  默认
     */
    LOADDING_DEF,
    /**
     *  只覆盖navigation以下部分
     */
    LOADDING_FULL
};

@interface HSLoaddingVC : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *view1;
@property (nonatomic, strong) IBOutlet UIImageView *view2;
@property (nonatomic, strong) IBOutlet UIImageView *view3;

- (id)initWithView:(UIView*)view;
- (id)initWithView:(UIView*)view Type:(LOADDING_TYPE)type;
-(void)show;
-(void)hide;
-(void)hideAfterDelay:(NSTimeInterval)delay;
-(void)setTipText:(NSString *)title;
@end
