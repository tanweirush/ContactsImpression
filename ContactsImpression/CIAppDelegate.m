//
//  CIAppDelegate.m
//  ContactsImpression
//
//  Created by 谭伟 on 14-2-20.
//  Copyright (c) 2014年 谭伟. All rights reserved.
//

#import "CIAppDelegate.h"

@interface CIAppDelegate ()

@end

@implementation CIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.root = [[UINavigationController alloc] init];
    self.vc_mainList = [[CIReviewListVC alloc] init];
    [self.root pushViewController:self.vc_mainList animated:NO];
    
    //引导页
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (![app_Version isEqualToString:[UserDef getUserDefValue:USER_LOCALVERSION]])
    {
        self.vc_guide = [[HSGuideVC alloc] init];
        [self.vc_guide setDelegate:self];
        [self.root pushViewController:self.vc_guide animated:NO];
        
        [self.root.navigationBar setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else
    {
        [self.root.navigationBar setHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    [UserDef setUserDefValue:app_Version keyName:USER_LOCALVERSION];
    
    
    self.window.rootViewController = self.root;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    if ([UINavigationBar instancesRespondToSelector:@selector(setBackgroundColor:)]){
//        [[UINavigationBar appearance] setBackgroundColor:UIColorFromARGB(0xff0c6024)];
//    }else {
//        [self.root.navigationBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]]
//                                     atIndex:1];
//    }
    
    if ([UINavigationBar instancesRespondToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"title.png"]
                                           forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.root.navigationBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]]
                                     atIndex:1];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self InitWatchData];
    if (self.vc_guide == nil)
    {
        [self updateContact];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)InitWatchData
{
    NSDate *date = [UserDef getUserDefValue:LAST_WATCH_Date];
    if (date == nil)
    {
        date = [NSDate date];
        [UserDef setUserDefValue:date keyName:LAST_WATCH_Date];
        [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_WATCH_Count];
        [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_EVALUATE_Count];
    }
    else
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
        NSDate *today = [cal dateFromComponents:components];
        components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
        NSDate *otherDate = [cal dateFromComponents:components];
        if (![today isEqualToDate:otherDate])
        {
            [UserDef setUserDefValue:[NSDate date] keyName:LAST_WATCH_Date];
            [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_WATCH_Count];
            [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_EVALUATE_Count];
        }
    }
    
#ifdef DEBUG_CasualLook
    [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_WATCH_Count];
    [UserDef setUserDefValue:[NSNumber numberWithInt:0] keyName:LAST_EVALUATE_Count];
    [UserDef setUserDefValue:[NSDate date] keyName:LAST_WATCH_Date];
#endif
}

-(void)updateContact
{
    [self.vc_mainList updateContact];
}

-(void)HSGuideVC:(HSGuideVC *)vc Start:(BOOL)start
{
    if (start)
    {
        [UIView transitionWithView:self.window.rootViewController.view
                          duration:0.333
                           options:UIViewAnimationOptionLayoutSubviews
                        animations:^{
                            [self.vc_guide.view setAlpha:0.0];
                        } completion:^(BOOL finished) {
                            [self.root popViewControllerAnimated:NO];
                            self.vc_guide = nil;
                            [[UIApplication sharedApplication] setStatusBarHidden:NO];
                            [self.root.navigationBar setHidden:NO];
                        }];
        
        [self performSelector:@selector(updateContact) withObject:nil afterDelay:1.0];
    }
}
@end
