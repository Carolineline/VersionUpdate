//
//  QYAdHocAppUpdateRequest.m
//  QYAppUpdate
//
//  Created by 晓琳 on 16/12/16.
//  Copyright © 2016年 icyleaf. All rights reserved.
//

#import "QYAdHocAppUpdateRequest.h"
#import "YTKNetworkPrivate.h"

#define Request_TimeOut 15
#define APIHost         @"http://mobile.2b6.me"     // mobile.2b6.me内测环境

@interface QYAdHocAppUpdateRequest ()<QYRequestLifecycle, QYBaseRequestDelegate>

@end

@implementation QYAdHocAppUpdateRequest

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
    NSString *url = @"http://mobile.2b6.me/api/v2/apps/latest";
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


//http://mobile.2b6.me/api/v2/apps/latest?id=com.qyer.qyerguide&key=91f52dee66f6b69a37707d52eba88253&release_version=7.2&build_version=12131748

- (NSMutableDictionary*)commonParamter
{
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
//    NSString *bundleId = @"com.qyer.qyerguide";
    NSString *deviceId = self.appKey;
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *currentBuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    [item setValue:bundleId forKey:@"id"];
    [item setValue:deviceId forKey:@"key"];
    [item setValue:currentVersion forKey:@"release_version"];
    [item setValue:currentBuildVersion forKey:@"build_version"];
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
    NSString *codeStr = [results objectForKey:@"error"];
    
    if (!codeStr) {
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
