//
//  YHWebViewController.h
//  YHWebViewController
//
//  Created by ruaho on 2018/8/2.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHEnumeration.h"
#import "YHWebView.h"

@interface YHWebViewController : UIViewController

/*
 * load type default is YHLoadWebTypeURLString
 */
@property (nonatomic, assign) YHLoadWebType loadWebType;

/*
 * load url is necessary
 */
@property (nonatomic, copy) NSString *openUrl;

/*
 * A Boolean value indicating whether realProgress is allowed.default is NO
 */
@property (nonatomic, assign) BOOL allowRealProgress;

/*
 * progressView Color.   default is rgb 
 */
@property (nonatomic, strong) UIColor *progressColor;

/*
 * webView The web view invoking the delegate method
 */
@property (nonatomic, copy) YHWebViewCallBack webCallBack;

/*
 * WKWebView to load url
 */
@property (nonatomic, strong) YHWebView *wkWebView;



@end
