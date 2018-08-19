//
//  YHEnumeration.h
//  YHWebViewController
//
//  Created by ruaho on 2018/8/19.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSUInteger, YHLoadWebType) {
    YHLoadWebTypeURLString = 1, // 加载url
    YHLoadWebTypeHTMLString,    // 加载本地html文件
    YHLoadWebTypeHTMLLabel      // 加载html标签
};

typedef NS_ENUM(NSUInteger, YHWebViewDelegate) {
    YHWebViewDidStart = 1,                  // 页面开始加载
    YHWebViewDidCommit,                     // 内容开始返回
    YHWebViewDidFinish,                     // 页面加载完成
    YHWebViewDidFail,                       // 页面加载失败
    YHWebViewDecidePolicyAction,            // 在发送请求之前，决定是否跳转
    YHWebViewDidReceiveAuthentication,      // 身份验证
    YHWebViewDecidePolicyResponse,          // 在收到响应后，决定是否跳转
    YHWebViewDidReceiveServerRedirect,      // 接收到服务器跳转请求之后
    YHWebViewDidFailNavigation,             // 导航错误
    YHWebViewDidTerminate                   // webView终止
};

typedef void(^YHWebViewObserver)(NSDictionary *observer);
typedef void(^YHWebViewCallBack)(YHWebViewDelegate callBackType,WKWebView *webView,NSError *error);



