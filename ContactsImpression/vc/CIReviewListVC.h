//
//  CIReviewListVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-24.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CILoginVC.h"
#import "NetServiceManager.h"
#import "CIEvaluateListVC.h"
#import "CIContactData.h"

@interface CIReviewListVC : UIViewController<
UIAlertViewDelegate,
CILoginVCDelegate,
NetFinishedDelegate,
CIContactDataDelegate,
CIEvaluateListVCDelegate>

@property (nonatomic, retain) IBOutlet UIView *v_tip;

@property (nonatomic, retain) IBOutlet UIButton *btn_self;
@property (nonatomic, retain) IBOutlet UIButton *btn_other;

-(void)startGetListData;
-(void)updateContact;
@end
