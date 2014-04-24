//
//  CIEvaluateListItemVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-4-1.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EvaluateListItemType)
{
    EvaluateListItemType_Self,
    EvaluateListItemType_Timeline,
    EvaluateListItemType_Friend,
};

@interface CIEvaluateListItemVC : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *img_arrow;
@property (nonatomic, retain) IBOutlet UIView *v_tip;
@property (nonatomic, retain) IBOutlet UILabel *lb_tipname;
@property (nonatomic, retain) IBOutlet UILabel *lb_tipstar;
@property (nonatomic, retain) IBOutlet UILabel *lb_tiptime;


@property (nonatomic, retain) IBOutlet UILabel *lb_name;
@property (nonatomic, retain) IBOutlet UILabel *lb_star;
@property (nonatomic, retain) IBOutlet UILabel *lb_time;
@property (nonatomic, retain) IBOutlet UILabel *lb_content;


- (id)initWithData:(id)data Type:(EvaluateListItemType)type Index:(NSInteger)index;
@end
