//
//  NetService.h
//  XianWu
//
//  Created by 谭伟 on 12-9-3.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "NSMutableArray+RemoveWithTag.h"

#ifndef DEBUG_TAN

//#define XU_HTTP_HEAD @"http://szd.ssimp.net/client" //http请求地址
//#define XU_IMG_HEAD @"http://szd.ssimp.net" //图片请求地址
#define XU_HTTP_HEAD @"http://szd-pre.ssimp.net/client" //http请求地址
#define XU_IMG_HEAD @"http://szd.ssimp.net" //图片请求地址

#else

#define XU_HTTP_HEAD @"http://dev.1gai.cn:10944/client" //http请求地址
#define XU_IMG_HEAD @"http://szd.ssimp.net" //图片请求地址

#endif

@protocol NetFinishedDelegate
@optional
-(void)LoginData:(id)data Tag:(NSInteger)tag;
-(void)UpdateContactsData:(id)data Tag:(NSInteger)tag;
-(void)FeedbackData:(id)data Tag:(NSInteger)tag;
-(void)TimelineData:(id)data Tag:(NSInteger)tag;
-(void)TrendData:(id)data Tag:(NSInteger)tag;
-(void)EvaluateData:(id)data Tag:(NSInteger)tag;
-(void)SetEvaluateData:(id)data Tag:(NSInteger)tag;
-(void)SetReadEvaluateData:(id)data Tag:(NSInteger)tag;
-(void)UserInfoData:(id)data Tag:(NSInteger)tag;
-(void)LogoutData:(id)data Tag:(NSInteger)tag;
-(void)ReplyListData:(id)data Tag:(NSInteger)tag;
-(void)ReplyTimeLineData:(id)data Tag:(NSInteger)tag;
-(void)SetPraiseData:(id)data Tag:(NSInteger)tag;
-(void)TimeLineOneData:(id)data Tag:(NSInteger)tag;
-(void)ImageData:(id)data Tag:(NSInteger)tag;
-(void)CheckUpData:(BOOL)NeedUpdata Tag:(NSInteger)tag;

@required
-(void)NoNeedUpdata:(NSInteger)tag Msg:(NSString*)m Result:(NSInteger)r;

@end

@interface NetServiceManager : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic, retain) id<NetFinishedDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;

-(void)LoginWithUserName:(NSString*)userName Password:(NSString*)pwd;
-(void)UpdateContacts:(NSMutableDictionary*)postData;
-(void)SendFeedback:(NSMutableDictionary*)postData;
-(void)GetTimeline:(NSMutableDictionary*)postData;
-(void)GetTrend:(NSMutableDictionary*)postData;
-(void)GetEvaluate:(NSMutableDictionary*)postData;
-(void)SetEvaluate:(NSMutableDictionary*)postData;
-(void)SetReadEvaluate:(NSMutableDictionary*)postData;
-(void)GetUserInfo:(NSMutableDictionary*)postData;
-(void)Logout:(NSMutableDictionary*)postData;
-(void)GetReplyList:(NSMutableDictionary*)postData;
-(void)SetReplyForTimeline:(NSMutableDictionary*)postData;
-(void)SetPraiseForTimeline:(NSMutableDictionary*)postData;
-(void)GetTimelineOne:(NSMutableDictionary*)postData;
-(void)GetImage:(NSString*)imgPath;
-(void)CheckUpData;

-(void)CancelRequest;
@end
