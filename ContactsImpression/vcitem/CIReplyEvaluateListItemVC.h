//
//  CIReplyEvaluateListItemVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-5-24.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIReplyEvaluateListItemVC : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *lb_floor;
@property (nonatomic, retain) IBOutlet UILabel *lb_reply;

- (id)initWithReply:(NSString*)reply Index:(NSInteger)index;

+(CGFloat)LabelHeighWithText:(NSString*)text;
@end
