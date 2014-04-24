//
//  GetPersonData.h
//  ContactsImpression
//
//  Created by 谭伟 on 14-2-21.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PersonData : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *phone;
@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, assign) NSInteger pid;

+(PersonData*)PersonData:(ABRecordRef)person LastDate:(NSDate*)date NeedUpdate:(int*)update;
@end
