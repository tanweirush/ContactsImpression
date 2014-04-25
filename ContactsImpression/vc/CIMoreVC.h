//
//  CIMainListVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-2-20.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetServiceManager.h"
#import "CILoginVC.h"

@class CIMoreVC;

@protocol CIMoreVCDelegate <NSObject>

-(void)CIMoreVC:(CIMoreVC*)vc Logout:(BOOL)bLogout;
-(void)CIMoreVC:(CIMoreVC*)vc Login:(BOOL)bLogin;

@end

@interface CIMoreVC : UIViewController<NetFinishedDelegate,
UIAlertViewDelegate,
CILoginVCDelegate>

@property (nonatomic, retain) id<CIMoreVCDelegate> delegate;
@end
