//
//  RemoveNetArray.m
//  XianWu
//
//  Created by 谭伟 on 12-11-15.
//
//

#import "NSMutableArray+RemoveWithTag.h"

@implementation NSMutableArray (RemoveObjectWithTag)

-(void)RemoveObjectWithTag:(NSInteger)tag
{
    NSEnumerator *items = [self objectEnumerator];
    id item = nil;
    while (item = [items nextObject])
    {
        if([item tag] == tag)
        {
            [self removeObject:item];
            break;
        }
    }
}
@end
