//
//  CIReadEvaluateVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-4-2.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CIEvaluateListItemVC.h"

@interface CIReadEvaluateVC : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *tv;

- (id)initWithData:(id)data Type:(EvaluateListItemType)type;
@end
