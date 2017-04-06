//
//  QYAppUpdateAlertView.m
//  QYAppUpdate
//
//  Created by 晓琳 on 16/12/21.
//  Copyright © 2016年 icyleaf. All rights reserved.
//

#import "QYAppUpdateAlertView.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"

#define kAlertViewWidth (UIScreenWidth - 50.0f)
#define kMessageViewMaxHeight 168.0

#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]
#define RGBA(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a / 100.0]
#define UIScreenWidth   [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight  [UIScreen mainScreen].bounds.size.height
#define IsEmpty(str) (![str respondsToSelector:@selector(isEqualToString:)] || [str isEqualToString:@""] || [str isEqualToString:@"(null)"])

#pragma mark - 屏幕尺寸判断
#define Is4Inch UIScreenWidth > 320
#define Is5Inch UIScreenWidth > 375

#pragma mark - 默认字体
#define Default_Font @"HY QiHei45"
#define Default_Number_Font @"ProximaNova-Light"
#define Default_Number_Font_Bold @"ProximaNova-Regular"
#define PingFangLight_Font @"PingFang-SC-Light"
#define PingFangRegular_Font  @"PingFangSC-Regular"
#define PingFangMedium_Font @"PingFangSC-Medium"
#define PingFangBold_Font @"PingFangSC-Semibold"

@interface QYAppUpdateAlertView ()

@property (strong, nonatomic) UITextView *messageTextView;

@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) UIButton *otherButton;

@property (strong, nonatomic) UIView *verticalLineView;

@property (strong, nonatomic) UIView *horizontalLineView;

@property (strong, nonatomic) RACSubject *confirmSignal;

@property (strong, nonatomic) QYAlertViewInfo *alertInfo;

@end


@implementation QYAppUpdateAlertView
- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2f] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 1.0); //设置阴影的偏移量
        self.layer.shadowRadius = 10;  //设置阴影的半径
        self.layer.shadowOpacity = 0.3f; //设置阴影的不透明度
        self.layer.cornerRadius = 6.0f;
    }
    return self;
}
    
    
#pragma mark - Setup
    
- (void)setupSubviews
{
    [self addSubview:self.messageTextView];
    [self addSubview:self.horizontalLineView];
    [self addSubview:self.cancelButton];
    
    if (self.alertInfo.buttonTitles.count == 2) {
        [self addSubview:self.verticalLineView];
        [self addSubview:self.otherButton];
    }else if (self.alertInfo.buttonTitles.count == 1) {
        NSString *title = self.alertInfo.buttonTitles[0];
        if ([title isEqualToString:@"立即更新"]) {
            [self.cancelButton setTitleColor:RGB(17, 191, 121) forState:UIControlStateNormal];
        }
    }
    
}

- (void)setupConstraints
{
    [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(18.5);
        make.width.mas_equalTo(kAlertViewWidth - 40);
    }];
    
    [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageTextView.mas_bottom);
        make.height.offset(0.5);
        make.left.right.equalTo(self);
    }];
    
    if (self.alertInfo.buttonTitles.count == 1) {
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.horizontalLineView.mas_bottom);
            make.height.offset(57.8f);
        }];
    }else if (self.alertInfo.buttonTitles.count == 2) {
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.top.equalTo(self.horizontalLineView.mas_bottom);
            make.right.equalTo(self.otherButton.mas_left);
            make.width.equalTo(self.otherButton);
            make.height.offset(57.8f);
        }];
        
        [self.otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.left.equalTo(self.cancelButton.mas_right);
            make.width.height.equalTo(self.cancelButton);
        }];
        
        [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cancelButton);
            make.centerX.equalTo(self);
            make.width.offset(0.5);
            make.height.offset(57.8f);
        }];
        
    }

}

- (void)setupEvents
{
    @weakify(self)
    self.cancelButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        
        [self.confirmSignal sendNext:@(0)];
            
        return [RACSignal empty];
    }];
        
    if (self.alertInfo.buttonTitles.count == 2) {
        
        self.otherButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
                
            [self.confirmSignal sendNext:@(1)];
                
            return [RACSignal empty];
        }];
            
    }
        
}
    
#pragma mark - QYAlertViewContentDelegate
    
- (void)alertContentDataSource:(QYAlertViewInfo *)alertViewInfo
{
    self.alertInfo = alertViewInfo;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1],
                                 NSFontAttributeName:[self fontWithName:PingFangRegular_Font size:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    if (!IsEmpty(alertViewInfo.message)) {
        self.messageTextView.attributedText = [[NSAttributedString alloc] initWithString:alertViewInfo.message attributes:attributes];
    }
    
    if (self.alertInfo.buttonTitles.count > 0) {
        [self.cancelButton setTitle:alertViewInfo.buttonTitles.firstObject forState:UIControlStateNormal];
    }
    
    if (self.alertInfo.buttonTitles.count == 2) {
        [self.otherButton setTitle:alertViewInfo.buttonTitles.lastObject forState:UIControlStateNormal];
    }
    
    [self setupSubviews];
    [self setupConstraints];
    [self setupEvents];
    
    [self.messageTextView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0.25];
}
    
- (CGSize)alertViewSize
{
    CGSize sizeThatFitsTextView = [self.messageTextView sizeThatFits:CGSizeMake((UIScreenWidth - 100), MAXFLOAT)];
    
    if (sizeThatFitsTextView.height >= kMessageViewMaxHeight) {
        return CGSizeMake(kAlertViewWidth, kMessageViewMaxHeight + 18.5 + 64.5);
    }else{
        return CGSizeMake(kAlertViewWidth, sizeThatFitsTextView.height + 18.5 + 64.5);
    }
    
}
    
- (RACSubject *)alertConfirmSignal
{
    return self.confirmSignal;
}


#pragma mark -  AutoGetter
    
- (RACSubject*)confirmSignal
{
    if (!_confirmSignal) {
        _confirmSignal = [RACSubject subject];
    }
        return _confirmSignal;
}
    
- (UITextView *)messageTextView
{
    if (!_messageTextView) {
        _messageTextView = [[UITextView alloc] init];
        _messageTextView.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
        _messageTextView.font = [self fontWithName:PingFangRegular_Font size:14];
        _messageTextView.editable = NO;
    }
    
    return _messageTextView;
}
    
- (UIView *)verticalLineView
{
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = RGBA(215, 215, 215, 100);
    }
    
    return _verticalLineView;
}
    
- (UIView *)horizontalLineView
{
    if (!_horizontalLineView) {
        _horizontalLineView = [[UIView alloc] init];
        _horizontalLineView.backgroundColor = RGBA(215, 215, 215, 100);
    }
    
    return _horizontalLineView;
}
    
- (UIButton*)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelButton.titleLabel.font = [self fontWithName:PingFangRegular_Font size:14];
        [_cancelButton setTitleColor:RGBA(149, 149, 149, 100) forState:UIControlStateNormal];
        
    }
        return _cancelButton;
}
    
- (UIButton*)otherButton
{
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _otherButton.titleLabel.font = [self fontWithName:PingFangMedium_Font size:14];
        [_otherButton setTitleColor:RGB(17, 191, 121) forState:UIControlStateNormal];
    }
    return _otherButton;
}
    
- (UIFont*)fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    CGFloat size = fontSize;
    if (Is5Inch) {
        size = fontSize + 1;
    }else if (Is4Inch) {
        
    }else {
        size = fontSize - 1;
    }
    
    UIFont *tempFont = [UIFont fontWithName:fontName size:size];
    
    if (tempFont) {
        return tempFont;
    }else {
        return [UIFont systemFontOfSize:size];
    }
}



@end
