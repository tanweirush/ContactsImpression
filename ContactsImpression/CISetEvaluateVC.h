//
//  CISetEvaluateVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-31.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetServiceManager.h"

@class CISetEvaluateVC;
@protocol CISetEvaluateVCDelegate <NSObject>

-(void)SetEvaluate:(CISetEvaluateVC*)vc Data:(id)data;

@end

@interface CISetEvaluateVC : UIViewController<UITextViewDelegate,
NetFinishedDelegate,
UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITextView *tv_evaluate;
@property (nonatomic, retain) id<CISetEvaluateVCDelegate> delegate;

- (id)initWithData:(id)data;
@end
