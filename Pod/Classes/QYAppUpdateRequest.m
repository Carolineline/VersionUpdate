//
//  QYAppUpdateRequest.m
//  QYAppUpdate
//
//  Created by 晓琳 on 16/12/16.
//  Copyright © 2016年 icyleaf. All rights reserved.
//

#import "QYAppUpdateRequest.h"

#define Request_TimeOut 15
#define APIHost             @"https://open.qyer.com"     // 产品环境

@interface QYAppUpdateRequest ()<QYRequestLifecycle, QYBaseRequestDelegate>

@end
@implementation QYAppUpdateRequest

- (id)initWithParamter:(NSDictionary *)paramterDic
{
    self = [super init];
    if (self) {
        _paramter = paramterDic;
    }
    return self;
}

/**
 *  请求的url
 *
 *  @return
 */
- (NSString *)requestUrl
{
    NSString *url = @"/qyer/startpage/check_version";
    return url;
}

#pragma mark - ShouldOverwrite

/**
 *  跟域名
 *
 *  @return
 */
- (NSString*)baseUrl
{
    return APIHost;
}

/**
 *  默认请求超时时间
 *
 *  @return
 */
- (NSTimeInterval)requestTimeoutInterval
{
    return Request_TimeOut;
}

/**
 *  请求方式
 *
 *  @return
 */
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}


//http://open.qyer.com/qyer/startpage/check_version?client_id=qyer_ios&client_secret=cd254439208ab658ddf9&track_app_channel=App%2520Store&version=7.0&build=7.0&track_os=ios%252010.1.1&track_user_id=1357827
- (NSMutableDictionary*)commonParamter
{
    NSString *clientId=[self.paramter objectForKey:@"clientId"];
    NSString *clientSecret=[self.paramter objectForKey:@"clientSecret"];
    NSString *trackAppChannel=[self.paramter objectForKey:@"trackAppChannel"];
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *currentBuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *trackOs = [UIDevice currentDevice].systemVersion;
    NSString *trackUser = [self.paramter objectForKey:@"trackUser"];
    NSString *hybVersion = [self.paramter objectForKey:@"hybVersion"];
    NSString *hybProjName = [self.paramter objectForKey:@"hybProjName"];
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    [item setValue:clientId forKey:@"client_id"];
    [item setValue:clientSecret forKey:@"client_secret"];
    [item setValue:trackAppChannel forKey:@"track_app_channel"];
    [item setValue:currentVersion forKey:@"version"];
    [item setValue:currentBuildVersion forKey:@"build"];
    [item setValue:trackOs forKey:@"track_os"];
    [item setValue:trackUser forKey:@"track_user"];
    [item setValue:hybVersion forKey:@"hyb_version"];
    [item setValue:hybProjName forKey:@"hyb_proj_name"];
    return item;
}


#pragma mark - QYBaseRequestDelegate

/**
 *  根据返回的状态码决定是否执行成功回调
 *
 *  @param results 接口返回数据
 *
 *  @return 返回YES则执行成功回调，NO则执行错误回调
 */
- (BOOL)isRequestSuccess:(id)results
{
    NSString *codeStr = [results objectForKey:@"status"];    
    if (codeStr.integerValue == 1) {
        return YES;
    }else {
        return NO;
    }
    
}

/**
 /**
 *  根据返回的数据获取错误消息
 *
 *  @param results 接口返回数据
 *
 *  @return 错误消息
 */
- (NSString *)handleErrorMessage:(id)results
{
    return [results objectForKey:@"error"];
}

- (NSInteger)handleErrorCode:(id)results
{
    return 1;
}
/**
 *  根据返回的数据判断数据状态
 *
 *  @param results 接口返回数据
 *
 *  @return 数据状态
 */
- (QYRequestMode)handleEmptyData:(id)results
{
    NSArray *array = results[@"commits"];
    
    if ([array isKindOfClass:[NSArray class]]) {
        if (array.count == 0) {
            return QYRequestModeEmptyData;
        }
    }
    
    return QYRequestModeSuccess;
}

/**
 *  预处理返回的数据
 *
 *  @param results 服务器返回的原始数据
 *
 *  @return 处理后的数据
 */
- (id)successResults:(id)results
{
    return results;
}

#pragma mark - QYRequestLifecycle

/**
 *  请求成功
 */
- (void)sendRequestDidSuccess:(QYBaseRequest*)request
{
    //    DDLogDebug(@"-");
    //    DDLogDebug(@"====================== Request Result ======================");
    //    DDLogDebug(@"isFromCache %@, results: %@", @(request.isDataFromCache), request.responseJSONObject);
    //    DDLogDebug(@"============================================================");
    //    DDLogDebug(@"-");
}

/**
 *  请求失败
 */
- (void)sendRequestDidFailure:(QYBaseRequest*)request
{
    NSLog(@"Request %@, Error: %@", request, request.responseString);
}



@end
