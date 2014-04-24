//
//  CIEvaluateListVC.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-31.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "CIEvaluateListItemVC.h"

@class CIEvaluateListVC;
@protocol CIEvaluateListVCDelegate <NSObject>

-(void)RefreshEvaluateList:(CIEvaluateListVC*)evaluateListVC;
-(void)LoadmoreEvaluateList:(CIEvaluateListVC*)evaluateListVC;
-(void)ReadEvaluate:(CIEvaluateListVC*)evaluateListVC EvaluateData:(id)data;
-(void)SelectEvaluate:(CIEvaluateListVC*)evaluateListVC EvaluateData:(id)data;
-(void)SelectNoEvaluate:(CIEvaluateListVC*)evaluateListVC;

@optional
-(void)ScrollDown:(CIEvaluateListVC*)evaluateListVC;
-(void)ScrollUp:(CIEvaluateListVC*)evaluateListVC;

@end

@interface CIEvaluateListVC : UIViewController<PullTableViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet PullTableView *tbv;
@property (nonatomic, assign) EvaluateListItemType type;
@property (nonatomic, retain) id<CIEvaluateListVCDelegate> delegate;

-(void)ReloadTableViewWithData:(NSMutableArray*)arr;
-(void)DataLoadOver;
-(void)DataLoadStart;

- (id)initWithFrame:(CGRect)frame Type:(EvaluateListItemType)type;
@end
