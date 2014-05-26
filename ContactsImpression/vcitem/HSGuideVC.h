//
//  HSGuideVC.h
//  HotelSupplies
//
//  Created by 谭伟 on 13-11-15.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSGuideVC;

@protocol HSGuideVCDelegate <NSObject>

-(void)HSGuideVC:(HSGuideVC*)vc Start:(BOOL)start;

@end

@interface HSGuideVC : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *sv_root;
@property (nonatomic, strong) IBOutlet UIButton *btn;

@property (nonatomic, retain) id<HSGuideVCDelegate> delegate;
@end
