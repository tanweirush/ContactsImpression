//
//  CIAppDelegate.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-2-20.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CIReviewListVC.h"
#import "HSGuideVC.h"

@interface CIAppDelegate : UIResponder <UIApplicationDelegate,
HSGuideVCDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *root;
@property (strong, nonatomic) CIReviewListVC *vc_mainList;
@property (strong, nonatomic) HSGuideVC *vc_guide;

@end
