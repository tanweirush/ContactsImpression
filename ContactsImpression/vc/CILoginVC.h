//
//  CILoginVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-26.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetServiceManager.h"

@protocol CILoginVCDelegate <NSObject>

-(void)LoginResult:(BOOL)success;

@end

@interface CILoginVC : UIViewController<UITextFieldDelegate,
NetFinishedDelegate>

@property (nonatomic, strong) IBOutlet UITextField *tf_phone;
@property (nonatomic, strong) IBOutlet UITextField *tf_vcode;
@property (nonatomic, strong) IBOutlet UIButton *btn_login;
@property (nonatomic, retain) id<CILoginVCDelegate> delegate;

@end
