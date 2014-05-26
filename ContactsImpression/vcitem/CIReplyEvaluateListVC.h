//
//  CIReplyEvaluateListVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-5-24.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetServiceManager.h"

@interface CIReplyEvaluateListVC : UIViewController<UITableViewDataSource,
UITableViewDelegate,
NetFinishedDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tbv;

- (id)initWithData:(NSDictionary*)data;
- (void)addReply:(NSString*)newReply;
@end
