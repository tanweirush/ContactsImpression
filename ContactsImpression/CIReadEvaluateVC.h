//
//  CIReadEvaluateVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-4-2.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CIEvaluateListItemVC.h"
#import "NetServiceManager.h"
#import "CISetEvaluateVC.h"
#import "CIReplyEvaluateListVC.h"


@interface CIReadEvaluateVC : UIViewController<NetFinishedDelegate,
CISetEvaluateVCDelegate,
CIReplyEvaluateListVCDelegate>

@property (nonatomic, strong) IBOutlet UILabel *lb_content;
@property (nonatomic, strong) IBOutlet UIView *v_tool;
@property (nonatomic, strong) IBOutlet UIButton *btn_praise;
@property (nonatomic, strong) IBOutlet UIImageView *iv_praise;

- (id)initWithData:(id)data Type:(EvaluateListItemType)type;
@end
