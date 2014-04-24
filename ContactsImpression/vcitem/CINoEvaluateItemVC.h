//
//  CINoEvaluateItemVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-4-3.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CINoEvaluateItemVC : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *lb_tip;

- (id)initWithTip:(NSString*)tip;
@end
