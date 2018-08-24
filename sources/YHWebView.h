//
//  YHWebView.h
//  YHWebViewController
//
//  Created by ruaho on 2018/8/17.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "YHEnumeration.h"

@interface YHWebView : WKWebView

@property (nonatomic, copy) YHWebViewObserver observer;
@property (nonatomic, copy) YHWebViewCallBack callBack;


@end
