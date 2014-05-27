//
//  CIReplyEvaluateListVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-5-24.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetServiceManager.h"

@class CIReplyEvaluateListVC;
@protocol CIReplyEvaluateListVCDelegate <NSObject>

@optional
-(void)ScrollDown:(CIReplyEvaluateListVC*)evaluateListVC;
-(void)ScrollUp:(CIReplyEvaluateListVC*)evaluateListVC;

@end


@interface CIReplyEvaluateListVC : UIViewController<UITableViewDataSource,
UITableViewDelegate,
NetFinishedDelegate,
UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tbv;
@property (nonatomic, retain) id<CIReplyEvaluateListVCDelegate> delegate;

- (id)initWithData:(NSDictionary*)data;
- (void)addReply:(NSString*)newReply;
@end
