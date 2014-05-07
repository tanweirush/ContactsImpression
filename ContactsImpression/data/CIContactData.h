//
//  CIContactData.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-3.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PersonData.h"

@class CIContactData;

@protocol CIContactDataDelegate <NSObject>


/**
 *  通讯录读取完毕
 *
 *  @param count 本次通讯录修改量
 */
-(void)ContactUpdateEnd:(NSInteger)count;

/**
 *  无通讯录读取权限
 */
-(void)ContactUpdateNoCompetence;

@end

@interface CIContactData : NSObject

@property (nonatomic, retain) id<CIContactDataDelegate> delegate;

-(void)UpdateData;
+(NSMutableArray*)contacts;
+(NSString*)Phone2Name:(id)phone;
+(NSString*)Pid2Name:(NSInteger)pid;
+(void)SetContactData:(NSArray*)data;
@end
