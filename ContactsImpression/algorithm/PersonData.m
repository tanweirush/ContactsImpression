//
//  GetPersonData.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-2-21.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "PersonData.h"

@implementation PersonData


+(PersonData*)PersonData:(ABRecordRef)person LastDate:(NSDate*)date NeedUpdate:(int *)update
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //最后更新时间kABPersonModificationDateProperty
    NSDate *lastModif = (__bridge NSDate *)(ABRecordCopyValue(person,kABPersonModificationDateProperty));
    if (nil == date || lastModif.timeIntervalSince1970 > date.timeIntervalSince1970)
    {
        *update = 1;
    }
    
    //读取firstname
    NSString *personName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    //读取lastname
    NSString *lastname = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    
    NSString *name = @"";
    
    if (lastname && [lastname length] > 0)
    {
        name = lastname;
    }
    if (personName && [personName length] > 0)
    {
        name = [name stringByAppendingString:personName];
    }
    
    //读取电话多值
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int k = 0; k < ABMultiValueGetCount(phone); k++)
    {
        //获取电话Label
//        NSString * personPhoneLabel = CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k)));
        //获取該Label下的电话值
        NSString * personPhone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
        
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        personPhone = [personPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([personPhone hasPrefix:@"+86"])
        {
            personPhone = [personPhone substringFromIndex:3];
        }
        
        if (personPhone.length != 11)
        {
            continue;
        }
        if ([arr indexOfObject:personPhone] == NSNotFound)
        {
            [arr addObject:personPhone];
        }
        else
        {
            NSLog(@"联系人重复: %@", name);
        }
    }
    
    if ([arr count] == 0)
    {
        return nil;
    }

    PersonData *data = [[PersonData alloc] init];
    data.name = name;
    data.phone = [[NSArray alloc] initWithArray:arr];
    
    return data;
}

@end
