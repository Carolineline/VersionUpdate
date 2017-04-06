//
//  QYAppUpdateModel.h
//  Pods
//
//  Created by 晓琳 on 16/12/23.
//
//

#import <Foundation/Foundation.h>

@interface QYAppUpdateModel : NSObject

@property (nonatomic, copy) NSString *clientId;

@property (nonatomic, copy) NSString *clientSecret;

@property (nonatomic, copy) NSString *trackAppChannel;

@property (nonatomic, copy) NSString *trackUserId;

@property (nonatomic, copy) NSString *hybVersion;

@property (nonatomic, copy) NSString *hybProjName;

@property (nonatomic, strong) Class updateAlertView;


@end
