//
//  QYAppUpdate.h
//  QYAppUpdate
//
//  Created by xiaolin.han on 15/12/19.
//  Copyright (c) 2015年 QYER. All rights reserved.
//

@class QYAppUpdateModel;


@interface QYAppUpdate : NSObject

typedef void (^QYUpdateVersionCompletion)(id item);

+ (void)checkAdHocWithAppKey:(NSString *)appKey andAlertClass:(Class)alertClass;

+ (void)checkAppVersionWithModel:(QYAppUpdateModel *)model;

+ (void)checkUpdateModel:(QYAppUpdateModel *)model andCompletion:(QYUpdateVersionCompletion)completion;

@end
