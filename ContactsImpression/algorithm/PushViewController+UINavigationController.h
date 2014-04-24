//
//  PushViewController+UINavigationController.h
//  SwanHotel
//
//  Created by 谭伟 on 13-7-25.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationController (pushViewController)

-(void)pushViewController:(UIViewController *)viewController TransitionType:(NSString*)tp SubType:(NSString*)subTp;
-(void)popViewControllerWithTransitionType:(NSString*)tp SubType:(NSString*)subTp;

@end
