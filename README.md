# QYAppUpdate

[![Version](https://img.shields.io/cocoapods/v/QYAppUpdate.svg?style=flat)](http://cocoadocs.org/docsets/QYAppUpdate)
[![License](https://img.shields.io/cocoapods/l/QYAppUpdate.svg?style=flat)](http://cocoadocs.org/docsets/QYAppUpdate)
[![Platform](https://img.shields.io/cocoapods/p/QYAppUpdate.svg?style=flat)](http://cocoadocs.org/docsets/QYAppUpdate)

## 安装

使用穷游内部的 [Cocoapods/Specs](http://gitlab.dev/cocoapods/specs) 作为 `Podfile` 的源仓库：


```ruby
source 'http://gitlab.dev/cocoapods/specs.git'

platform :ios, '8.0'

\#use_frameworks!

pod 'QYAppUpdate'
```

执行 `pod install` 即可安装成功，具体可以参考范例工程。

---
## 类介绍
| 类名      |    作用 | 
| :-------- | :--------| 
| QYAppUpdate  | 版本更新的抽象类 |  
| QYAppUpdateModel | 版本更新所需参数类 |
| QYAppUpdateRequest | 生产环境的网络请求 |
| QYAdHocAppUpdateRequest | adHoc环境的网络请求 |
| QYAppUpdateAlertView | 版本更新的默认提示框 |

##usage
- 项目需要在引入以下三个类：<br>

```
#import "QYAppUpdate.h"
#import "QYAppUpdateAlertView.h"
#import "QYAppUpdateModel.h"

```
- 检测内测环境adHoc是否有版本更新：<br>
调用类方法`+ (void)checkAdHocWithAppKey:(NSString *)appKey andAlertClass:(Class)alertClass;`<br>
传入所需参数appKey和所展示提示框的类，如果用户使用自定义的提示框直接在这里传入，如果没有自定义可默认使用`QYAppUpdateAlertView`<br>

```
[QYAppUpdate checkAdHocWithAppKey:@"91f52dee66f6b69a37707d52eba88253"
                        andAlertClass:[QYAppUpdateAlertView class]];
```
- 检测生产环境是否有版本更新：<br>
调用类方法`+ (void)checkAppVersionWithModel:(QYAppUpdateModel *)model;`<br>
创建版本更新所需参数的`QYAppUpdateModel`对象，给该对象赋值，传入该方法<br>
并需要给`QYAppUpdateModel`对象的`updateAlertView`属性设置提示框的样式类，如果用户使用自定义的提示框直接在这里设置，如果没有自定义可默认设置为`QYAppUpdateAlertView`<br>


```
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

```

## Author

韩晓琳, xiaolin.han@qyer.com

## License

QYAppUpdate is available under the MIT license. See the LICENSE file for more info.




# VersionUpdate
