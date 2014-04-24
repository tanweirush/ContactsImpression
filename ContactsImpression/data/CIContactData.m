//
//  CIContactData.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-3-3.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIContactData.h"

static NSMutableArray *s_listContacts;
static NSMutableArray *s_update;

@interface CIContactData ()

@property (nonatomic, retain) NSDate *lastDate;

@end

@implementation CIContactData

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        if (s_listContacts == nil)
        {
            s_listContacts = [[NSMutableArray alloc] init];
        }
        if (s_update == nil)
        {
            s_update = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(void)UpdateData
{
    self.lastDate = nil;
    NSString *s = [UserDef getUserDefValue:USER_SESSION];
    if (s && s.length > 0)
    {
        self.lastDate = [UserDef getUserDefValue:LASTUPDATE(s)];
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook == nil)
    {//未授权
        [self.delegate ContactUpdateNoCompetence];
        return;
    }
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            [self performSelectorInBackground:@selector(Reload) withObject:nil];
        }
    });
    CFRelease(addressBook);
}

-(void)Reload
{
    //查询所有
    [self filterContentForSearchText:@""];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    //如果没有授权则退出
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return ;
    }
    
    NSMutableArray *listContacts = [[NSMutableArray alloc] init];
    [s_update removeAllObjects];
    
    CFErrorRef error = NULL;
    CFArrayRef allPerson;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if([searchText length]==0)
    {
        //查询所有
        allPerson = ABAddressBookCopyArrayOfAllPeople(addressBook);
    }
    else {
        //条件查询
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        allPerson = ABAddressBookCopyPeopleWithName(addressBook, cfSearchText);
        CFRelease(cfSearchText);
    }
    
    for(int i = 0; i < CFArrayGetCount(allPerson); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(allPerson, i);
        
        int update = 0;
        PersonData *personData = [PersonData PersonData:person LastDate:self.lastDate NeedUpdate:&update];
        if (personData)
        {
            personData.pid = i;
            if (update)
            {
                [s_update addObject:[NSNumber numberWithInt:i]];
                [listContacts addObject:personData];
            }
            else
            {
                [listContacts addObject:personData];
            }
        }
    }
    
    s_listContacts = listContacts;
    
    CFRelease(addressBook);
    
    [self.delegate ContactUpdateEnd:[s_update count]];
}

+(NSMutableArray*)contacts
{
    return s_listContacts;
}

+(NSArray*)needUpdateContactsIndexs
{
    return s_update;
}

+(NSString*)Phone2Name:(id)phone
{
    NSString *name = @"";
    NSMutableArray *tmpPhones = [[NSMutableArray alloc] initWithCapacity:[phone count]];
    for (PersonData *personData in s_listContacts)
    {
        if ([personData.phone count] == [phone count])
        {
            [tmpPhones removeAllObjects];
            [tmpPhones addObjectsFromArray:personData.phone];
            int i = 0, j = 0;
            while (i < [phone count] && j < [tmpPhones count])
            {
                if ([[phone objectAtIndex:i] isEqualToString:[tmpPhones objectAtIndex:j]])
                {
                    [tmpPhones removeObjectAtIndex:j];
                    ++i;
                    j = 0;
                    continue;
                }
                ++j;
            }
            if ([tmpPhones count] == 0)
            {
                name = personData.name;
                if (name.length == 0)
                {
                    name = [personData.phone objectAtIndex:0];
                }
                break;
            }
        }
    }
    return name;
}

+(NSString*)Pid2Name:(NSInteger)pid
{
    NSString *name = @"";
    for (PersonData *personData in s_listContacts)
    {
        if (personData.pid == pid)
        {
            name = personData.name;
            if (name.length == 0)
            {
                name = [personData.phone objectAtIndex:0];
            }
            break;
        }
    }
    return name;
}

+(void)SetContactData:(NSArray*)data
{
    NSMutableArray *listContacts = [[NSMutableArray alloc] init];
    s_update = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSDictionary *dic in data)
    {
        PersonData *personData = [[PersonData alloc] init];
        personData.name = [dic objectForKey:CI_NAME];
        personData.phone = [dic objectForKey:CI_PHONES];
        personData.pid = [[dic objectForKey:CI_PID] integerValue];
        [s_update addObject:[NSNumber numberWithInt:i++]];
        [listContacts addObject:personData];
    }
    s_listContacts = listContacts;
}
@end
