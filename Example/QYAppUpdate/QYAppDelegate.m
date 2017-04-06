//
//  QYAppDelegate.m
//  QYAppUpdate
//
//  Created by 晓琳 on 16/12/16.
//  Copyright © 2016年 icyleaf. All rights reserved.
//

#import "QYAppDelegate.h"

#import "QYAppUpdate.h"
#import "QYAppUpdateAlertView.h"
#import "QYAppUpdateModel.h"
@implementation QYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //内测
#if ADHOC
    [QYAppUpdate checkAdHocWithAppKey:@"91f52dee66f6b69a37707d52eba88253"
                        andAlertClass:[QYAppUpdateAlertView class]];
    #else
    //产品

    QYAppUpdateModel *model = [[QYAppUpdateModel alloc] init];
    NSDictionary *dic = @{@"clientId":@"qyer_ios",
                      @"clientSecret":@"cd254439208ab658ddf9",
                   @"trackAppChannel":@"App%2520Store",
                       @"trackUserId":@"1357827",
                        @"hybVersion":@"",
                       @"hybProjName":@""};
    [model setValuesForKeysWithDictionary:dic];
    model.updateAlertView = [QYAppUpdateAlertView class];
    [QYAppUpdate checkAppVersionWithModel:model];
    
#endif
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
