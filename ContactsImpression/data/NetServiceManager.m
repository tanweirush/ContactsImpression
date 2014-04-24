//
//  NetService.m
//  XianWu
//
//  Created by 谭伟 on 12-9-3.
//
//

#import "NetServiceManager.h"
#import "UserDef.h"
#import "JSONKit.h"


#define XU_URL(t) [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", XU_HTTP_HEAD, t]]
#define XU_IMGURL(t) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", XU_IMG_HEAD, t]]

#define XU_NET_TIMEOUT 10

//http请求内容
#define XU_ACTION_LOGIN @"register"
#define XU_ACTION_GETVCODE @"vcode"
#define XU_ACTION_UPDATECONTACT @"contacts"
#define XU_ACTION_FEEDBACK @"feedback"
#define XU_ACTION_TIMELINE @"timeline"
#define XU_ACTION_TREND @"trend"
#define XU_ACTION_EVALUATE @"evaluate"
#define XU_ACTION_SETEVALUATE @"setevaluate"
#define XU_ACTION_SETREAD @"setread"
#define XU_ACTION_USERINFO @"userinfo"

/**
 *  网络操作列表
 */
typedef NS_ENUM(NSInteger, NetTagType)
{
    /**
     *  登录
     */
    na_login = 0,
    /**
     *  获取图片
     */
    na_img = 1,
    /**
     *  获取验证码
     */
    na_getvcode = 2,
    /**
     *  更新通讯录
     */
    na_updatecontact = 3,
    /**
     *  意见反馈
     */
    na_feedback = 4,
    /**
     *  联系人动态
     */
    na_timeline = 5,
    /**
     *  个人动态
     */
    na_trend,
    /**
     *  特定联系人动态
     */
    na_evaluate,
    /**
     *  评论
     */
    na_setevaluate,
    /**
     *  设置已读
     */
    na_setread,
    /**
     *  获取用户信息
     */
    na_userinfo,
    
    
    /**
     *  自动更新
     */
    na_updata = 50,
};

@interface NetServiceManager ()

@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSMutableDictionary *tmpData;

@end

@implementation NetServiceManager
@synthesize tmpData = _tmpData;

static NSDate *s_time;

-(void)LoginWithUserName:(NSString *)userName Password:(NSString *)pwd
{
    NSString *phone_uid = [UserDef getUserDefValue:PHONE_UID];
    NSURL *url = XU_URL(XU_ACTION_LOGIN);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    
    self.tmpData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userName, POST_USERNAME, nil];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userName forKey:POST_USERNAME];
    [dic setValue:pwd forKey:POST_PASSWORD];
    [dic setValue:[NSNumber numberWithInteger:0] forKey:POST_DEVICE];
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [dic setValue:s forKey:CTRL_Session];
    }
    
    if(phone_uid && phone_uid.length > 0)
    {
        [dic setValue:phone_uid forKey:POST_PhoneID];
    }
//    [request setValidatesSecureCertificate:NO];
    [request appendPostData:[dic JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_login];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request startAsynchronous];
    self.request = request;
    
    NSLog(@"log : \n%@", dic);
}

-(void)GetVCode:(NSMutableDictionary *)postData
{
    NSURL *url = XU_URL(XU_ACTION_GETVCODE);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_getvcode];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request startAsynchronous];
    self.request = request;
}

-(void)UpdateContacts:(NSMutableDictionary *)postData
{
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [postData setValue:s forKey:CTRL_Session];
    }
    
    NSURL *url = XU_URL(XU_ACTION_UPDATECONTACT);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_updatecontact];
    [request setTimeOutSeconds:XU_NET_TIMEOUT * 5];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request startAsynchronous];
    self.request = request;
}

-(void)SendFeedback:(NSMutableDictionary *)postData
{
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [postData setValue:s forKey:CTRL_Session];
    }
    
    NSURL *url = XU_URL(XU_ACTION_FEEDBACK);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_feedback];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request startAsynchronous];
    self.request = request;
}

-(void)GetTimeline:(NSMutableDictionary *)postData
{
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [postData setValue:s forKey:CTRL_Session];
    }
    else
    {
        [self.delegate NoNeedUpdata:self.tag Msg:nil Result:1];
        return;
    }
    
    NSURL *url = XU_URL(XU_ACTION_TIMELINE);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_timeline];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request startAsynchronous];
    self.request = request;
}

-(void)GetTrend:(NSMutableDictionary *)postData
{
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [postData setValue:s forKey:CTRL_Session];
    }
    else
    {
        [self.delegate NoNeedUpdata:self.tag Msg:nil Result:1];
        return;
    }
    
    NSURL *url = XU_URL(XU_ACTION_TREND);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_trend];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request startAsynchronous];
    self.request = request;
}

-(void)GetEvaluate:(NSMutableDictionary *)postData
{
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [postData setValue:s forKey:CTRL_Session];
    }
    else
    {
        [self.delegate NoNeedUpdata:self.tag Msg:nil Result:1];
        return;
    }
    
    NSURL *url = XU_URL(XU_ACTION_EVALUATE);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_evaluate];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request startAsynchronous];
    self.request = request;
}

-(void)SetEvaluate:(NSMutableDictionary *)postData
{
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [postData setValue:s forKey:CTRL_Session];
    }
    else
    {
        [self.delegate NoNeedUpdata:self.tag Msg:nil Result:1];
        return;
    }
    
    NSURL *url = XU_URL(XU_ACTION_SETEVALUATE);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_setevaluate];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request startAsynchronous];
    self.request = request;
}

-(void)SetReadEvaluate:(NSMutableDictionary *)postData
{
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [postData setValue:s forKey:CTRL_Session];
    }
    else
    {
        [self.delegate NoNeedUpdata:self.tag Msg:nil Result:1];
        return;
    }
    
    NSURL *url = XU_URL(XU_ACTION_SETREAD);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_setread];
    [request setTimeOutSeconds:XU_NET_TIMEOUT * 2];
    [request setNumberOfTimesToRetryOnTimeout:5];
    [request startAsynchronous];
    self.request = request;
}

-(void)GetUserInfo:(NSMutableDictionary *)postData
{
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        [postData setValue:s forKey:CTRL_Session];
    }
    else
    {
        [self.delegate NoNeedUpdata:self.tag Msg:nil Result:1];
        return;
    }
    
    NSURL *url = XU_URL(XU_ACTION_USERINFO);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request appendPostData:[postData JSONData]];
    [request setRequestMethod:@"POST"];
    [request setTag:na_userinfo];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:5];
    [request startAsynchronous];
    self.request = request;
}

-(void)GetImage:(NSString*)imgPath
{
    NSURL *url = XU_IMGURL(imgPath);
    self.tmpData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:imgPath, @"images", nil];
    
    ASIHTTPRequest *net = [ASIHTTPRequest requestWithURL:url];
    [net setTag:na_img];
    [net setDelegate:self];
    [net startAsynchronous];
    self.request = net;
}

-(void)CheckUpData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APPLE_ID]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setTag:na_updata];
    [request setDelegate:self];
    [request setTimeOutSeconds:XU_NET_TIMEOUT];
    [request setNumberOfTimesToRetryOnTimeout:0];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request startAsynchronous];
    self.request = request;
}

-(void)CancelRequest
{
    [self.request clearDelegatesAndCancel];
    [self.request cancel];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    if(request.tag != na_img)
    {
        [self.delegate NoNeedUpdata:self.tag Msg:@"网络超时啦" Result:Return_NetTimeOut];
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(s_time)
    {
//        int time = s_time.timeIntervalSinceNow;
//        NSLog(@"get hotellist time = %d秒", -time);
    }
    NSString *responseString = [request responseString];
    NSDictionary *tmp = [responseString objectFromJSONString];
    NSNumber *update = [tmp objectForKey:CTRL_Return];
    if(nil == update || [update integerValue] != 0)
    {//数据错误
        if(request.tag == na_img)
        {//获取图片，则继续执行
        }
        else if(request.tag == na_updata)
        {
            NSArray *configData = [tmp valueForKey:@"results"];
            NSString *version = nil;
            for (id config in configData)
            {
                version = [config valueForKey:@"version"];
            }
            if(version == nil)
            {
                [self.delegate CheckUpData:NO Tag:self.tag];
                return;
            }
            [UserDef setUserDefValue:version keyName:USER_NETVERSION];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            //Check your version with the version in app store
            if (![version isEqualToString:app_Version])
            {
                [self.delegate CheckUpData:YES Tag:self.tag];
            }
            else
            {
                [self.delegate CheckUpData:NO Tag:self.tag];
            }
            return;
        }
        else
        {
            [self.delegate NoNeedUpdata:self.tag Msg:[tmp objectForKey:CTRL_Msg] Result:[update integerValue]];
            return;
        }
    }
    NSDictionary *dic = [tmp objectForKey:CTRL_Data];
    switch (request.tag)
    {
        case na_login:
        {
            if(self.tmpData && [self.tmpData objectForKey:POST_USERNAME])
            {
                [UserDef setUserDefValue:[self.tmpData objectForKey:POST_USERNAME] keyName:USER_NAME];
            }
            [self.delegate LoginData:dic Tag:self.tag];
        }
            break;
        case na_getvcode:
        {
            [self.delegate VCodeData:dic Tag:self.tag];
        }
            break;
        case na_updatecontact:
        {
            [self.delegate UpdateContactsData:dic Tag:self.tag];
        }
            break;
        case na_feedback:
        {
            [self.delegate FeedbackData:dic Tag:self.tag];
        }
            break;
        case na_timeline:
        {
            [self.delegate TimelineData:dic Tag:self.tag];
        }
            break;
        case na_trend:
        {
            [self.delegate TrendData:dic Tag:self.tag];
        }
            break;
        case na_evaluate:
        {
            [self.delegate EvaluateData:dic Tag:self.tag];
        }
            break;
        case na_setevaluate:
        {
            [self.delegate SetEvaluateData:dic Tag:self.tag];
        }
            break;
        case na_setread:
        {
            [self.delegate SetReadEvaluateData:dic Tag:self.tag];
        }
            break;
        case na_userinfo:
        {
            [self.delegate UserInfoData:dic Tag:self.tag];
        }
            break;
        case na_img:
        {
            NSData *data = [request responseData];
            if(nil != data)
            {
                NSString *file = [self.tmpData objectForKey:@"images"];
                file = [file stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                [data writeToFile:File_Path(file) atomically:NO];
                [self.delegate ImageData:data Tag:self.tag];
            }
        }
            break;
        default:
            break;
    }
}

@end
