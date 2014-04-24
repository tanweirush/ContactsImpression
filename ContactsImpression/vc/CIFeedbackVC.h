//
//  CIFeedbackVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-25.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetServiceManager.h"

@interface CIFeedbackVC : UIViewController<UITextViewDelegate,
NetFinishedDelegate>

@property (nonatomic, strong) IBOutlet UITextView *tv;

@end
