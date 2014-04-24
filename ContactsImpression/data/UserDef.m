//
//  UserDef.cpp
//  XianWu
//
//  Created by Wei Tan on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "UserDef.h"


@interface UserDef ()

@end

@implementation UserDef

/**
 *  获取NSUserDefaults的值
 *
 *  @param key 键值
 *
 *  @return key对应的值
 */
+(id)getUserDefValue:(NSString*)key
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:key];
}

/**
 *  设置NSUserDefaults
 *
 *  @param value 值
 *  @param key   键
 */
+(void)setUserDefValue:(id)value keyName:(NSString*)key
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:value forKey:key];
    [userDefaults synchronize];
}

+(void)removeObjectForKey:(NSString*)key
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

+(void)synchronize
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
}

@end