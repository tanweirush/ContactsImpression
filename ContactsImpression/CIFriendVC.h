//
//  CIFriendVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-31.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CIEvaluateListVC.h"
#import "NetServiceManager.h"
#import "CISetEvaluateVC.h"

@interface CIFriendVC : UIViewController<CIEvaluateListVCDelegate,
NetFinishedDelegate,
CISetEvaluateVCDelegate>

- (id)initWithData:(id)data;
@end
