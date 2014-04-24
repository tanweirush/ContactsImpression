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

@interface CIMoreVC : UIViewController<NetFinishedDelegate,
UIAlertViewDelegate,
CILoginVCDelegate>
@end
