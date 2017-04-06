//
//  QYAdHocAppUpdateRequest.h
//  QYAppUpdate
//
//  Created by 晓琳 on 16/12/16.
//  Copyright © 2016年 icyleaf. All rights reserved.
//

#import "QYBaseRequest.h"

@interface QYAdHocAppUpdateRequest : QYBaseRequest

@property (nonatomic, retain) NSDictionary *paramter;

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, strong) Class updateAlertView;
@end
