//
//  UserDef.h
//  Platform
//
//  Created by Wei Tan on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Platform_UserDef_h
#define Platform_UserDef_h

//NSUserDefaults key
#define PHONE_UID @"phone_uid"  //手机UID
#define USER_NAME @"UserName"   //用户注册名(一个手机号)
#define USER_SESSION @"UserSession"   //用户唯一sesion
#define USER_NETVERSION @"UserNetVersion"   //网络端最高版本
#define USER_LOCALVERSION @"UserLocalVersion"   //本地的上次版本
#define LASTUPDATE(TAG) [NSString stringWithFormat:@"lastdate_%@", TAG] //最后更新通讯录时间
#define LAST_WATCH_Date @"LastWatchDate" //最后查看时间
#define LAST_WATCH_Count @"LastWatchCount" //最后查看条数
#define LAST_EVALUATE_Count @"LastEvaluateCount" //最后评论条数
#define FIRST_UPLOAD_CONTACT @"FirstUploadContact" //是否为首次上传通讯录

//全局json key
#define CTRL_Return @"r" //返回状态码 0：成功
#define CTRL_Action @"ac" //请求时的操作代码
#define CTRL_Data @"d" //数据内容
#define CTRL_Msg @"m" //返回状态描述
#define CTRL_Session @"s" //用户标示
#define CTRL_PAGE @"pg"
#define CI_CONTENT @"content" //内容
#define CI_LIST @"list" //列表数据

//post json  key
#define POST_PhoneID @"puid"    //手机id
#define POST_USERNAME @"u"
#define POST_PASSWORD @"vcode"
#define POST_DEVICE @"device" //设备类型：0、iphone

//通用属性json key
#define CI_STAR @"star" //星级
#define CI_PID @"pid" //联系人id
#define CI_NAME @"n" //联系人名字
#define CI_PHONES @"phone" //联系人电话
#define CI_CONTACT @"contact" //通讯录
#define CI_TID @"tid" //评论id
#define CI_READ @"read" //是否已读
#define CI_TIME @"time" //时间
#define CI_READNUM @"readnum" //每日阅读
#define CI_EVLNUM @"evaluatenum" //每日评价

//CTRL_Return
#define Return_NeedRelogin 2 //需要重新登录
#define Return_NetTimeOut 3 //网络超时


@interface UserDef : NSObject


+(id)getUserDefValue:(NSString*)key;
+(void)setUserDefValue:(id)value keyName:(NSString*)key;
+(void)removeObjectForKey:(NSString*)key;
+(void)synchronize;

@end

#endif
