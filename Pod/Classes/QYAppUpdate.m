//
//  QYAppUpdate.m
//  QYAppUpdate
//
//  Created by xiaolin.han on 15/12/19.
//  Copyright (c) 2015年 QYER. All rights reserved.
//

#import "QYAppUpdate.h"

#import "QYAdHocAppUpdateRequest.h"
#import "QYAppUpdateRequest.h"
#import "QYAlertView+RACSignalSupport.h"
#import "QYAppUpdateAlertView.h"
#import "ReactiveCocoa.h"
#import "QYAppUpdateModel.h"
#import "NSString+CRLVersionComparison.h"

@interface QYAppUpdate ()<UIAlertViewDelegate>

@property (nonatomic, strong) QYAdHocAppUpdateRequest *adHocRequest;

@property (nonatomic, strong) QYAppUpdateRequest *appRequest;

@property (nonatomic, strong) QYAppUpdate *update;

@end

@implementation QYAppUpdate

+ (instancetype)shared
{
    static QYAppUpdate *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QYAppUpdate alloc] init];
        instance.update = instance;
    });
    
    return instance;
}

#pragma mark -- mobile.2b6.me
+ (void)checkAdHocWithAppKey:(NSString *)appKey andAlertClass:(Class)alertClass;
{
    [[QYAppUpdate shared].update checkAdHocWithAppKey:appKey andAlertClass:alertClass];
}

- (void)checkAdHocWithAppKey:(NSString *)appKey andAlertClass:(Class)alertClass
{
    self.adHocRequest.appKey = appKey;
    
    [self.adHocRequest startWithSuccess:^(id results, QYBaseRequest *request) {

        NSDictionary *dic = results;
        Class alertViewClass = [QYAppUpdateAlertView class];
        if ([alertClass isSubclassOfClass:[UIView class]] && [alertClass conformsToProtocol:@protocol(QYAlertViewContentDelegate)]) {
            alertViewClass = alertClass;
        }
        
        if ([self hasNewVersionWithReleaseVersion:[dic valueForKey:@"release_version"] buildVersion:[dic valueForKey:@"build_version"]]) {
            [self showAlert:alertViewClass alertInfo:dic];
        }
            
    } failure:^(QYBaseRequest *request) {
        
        NSLog(@"request = %@", request);

    }];
}

- (QYAdHocAppUpdateRequest *)adHocRequest
{
    if (!_adHocRequest) {
        _adHocRequest = [[QYAdHocAppUpdateRequest alloc] init];
    }
    return _adHocRequest;
}

#pragma mark -- open.qyer.com
+ (void)checkAppVersionWithModel:(QYAppUpdateModel *)model
{
    [QYAppUpdate checkUpdateModel:model andCompletion:^(id completion) {
        
        NSMutableDictionary *dic = completion;
        NSDictionary *infoDic = [dic objectForKey:@"data"];
        
        Class alertClass = [QYAppUpdateAlertView class];
        if ([model.updateAlertView isSubclassOfClass:[UIView class]] && [model.updateAlertView conformsToProtocol:@protocol(QYAlertViewContentDelegate)]) {
            alertClass = model.updateAlertView;
        }
        
        [[QYAppUpdate shared] showAlert:alertClass alertInfo:infoDic];

    }];
}

- (QYAppUpdateRequest *)appRequest
{
    if (!_appRequest) {
        _appRequest = [[QYAppUpdateRequest alloc] init];
    }
    return _appRequest;
}

#pragma alert - show

- (void)showAlert:(Class)alertClass alertInfo:(NSDictionary *)info
{
    if (info == [NSNull null] || info == NULL || !info) {
        NSLog(@"alertInfoError = %@",info);
        return ;
    }
    if (!alertClass) {
        NSLog(@"alertClassError = %@",alertClass);

        return;
    }
    NSString *message = [info objectForKey:@"changelog"];
    NSString *urlStr = [info objectForKey:@"link"];
    
    if (urlStr  == NULL || [urlStr isEqualToString:@""] || !urlStr) {
        urlStr = [info objectForKey:@"install_url"];
    }
   
    NSArray *titles = @[@"下次再说", @"立即更新"];
    
    QYAlertView *alertView = [[QYAlertView alloc] initWithTitle:nil
                                                        message:message
                                                          style:QYAlertViewStyleAlert
                                                       delegate:nil
                                                   buttonTitles:titles];
    [alertView registerClass:alertClass];
    [alertView show];
    [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
        
        if ([x integerValue] == 1) {
            
            NSURL *appURL = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:appURL];
        }
    }];
}

+ (void)checkUpdateModel:(QYAppUpdateModel *)model andCompletion:(QYUpdateVersionCompletion)completion
{
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    [item setValue:model.clientId forKey:@"clientId"];
    [item setValue:model.clientSecret forKey:@"clientSecret"];
    [item setValue:model.trackAppChannel forKey:@"trackAppChannel"];
    [item setValue:model.trackUserId forKey:@"trackUserId"];
    [item setValue:model.hybVersion forKey:@"hybVersion"];
    [item setValue:model.hybProjName forKey:@"hybProjName"];
    [QYAppUpdate shared].appRequest.paramter = item;
    
    [[QYAppUpdate shared].appRequest startWithSuccess:^(id results, QYBaseRequest *request) {
        if (completion) {
            completion(results);
        }
        
    } failure:^(QYBaseRequest *request) {
        if (completion) {
            completion(request);
        }
    }];
}

- (BOOL)hasNewVersionWithReleaseVersion:(NSString *)releaseVersion buildVersion:(NSString *)buildVersion
{
    
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *currentBuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    // Compare version first
    NSComparisonResult comparison = [currentVersion crl_dottedVersionCompare:releaseVersion];
    if(comparison == NSOrderedAscending) return YES;
    if(comparison == NSOrderedDescending) return NO;
    
    // If the major versions are equal, check the build number
    if(buildVersion && buildVersion.length > 0)
        comparison = [currentBuildVersion crl_dottedVersionCompare:buildVersion];
    
    return comparison == NSOrderedAscending;

    return NO;
}

@end


