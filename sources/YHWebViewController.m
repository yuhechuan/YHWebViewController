//
//  YHWebViewController.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/2.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHWebViewController.h"
#import <WebKit/WebKit.h>

static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface YHWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation YHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


- (void)loadWebViewURL{
    switch (self.loadWebType) {
        case YHLoadWebTypeURLString:{
            [self loadURLString];
            break;
        }
        case YHLoadWebTypeHTMLString:{
            [self loadHostPathURL:self.openUrl];
            break;
        }
        case YHLoadWebTypePOSTString:{
            //self.needLoadJSPOST = YES;
            [self loadHostPathURL:@"WKJSPOST"];
            break;
        }
    }
}

- (void)loadHostPathURL:(NSString *)url{
    NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:@"html"];
    NSError *error = nil;
    NSString *html = [[NSString alloc]initWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
    //加载js
    [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)loadURLString {
    self.view.clipsToBounds = YES;
    NSURLRequest* loadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[self encodeUrl]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [self.wkWebView loadRequest:loadRequest];
}

- (NSString *)encodeUrl {
    if ([self.openUrl containsString:@"?"]) {
        NSArray *urlArr = [self.openUrl componentsSeparatedByString:@"?"];
        NSString *host = urlArr[0];
        NSString *queryStr = [self.openUrl substringFromIndex:host.length];
        queryStr = [self encode:queryStr];
        return [NSString stringWithFormat:@"%@%@", host, queryStr];
    }
    return self.openUrl;
}

// encode 字符串
- (NSString *)encode:(NSString *)str {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
}


- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsAirPlayForMediaPlayback = YES;//允许视频播放
        configuration.allowsInlineMediaPlayback = YES;    // 允许在线播放
        configuration.selectionGranularity = YES;         // 允许可以与网页交互，选择视图

        configuration.processPool = [[WKProcessPool alloc] init]; // web内容处理池

        WKUserContentController *userContentController = [[WKUserContentController alloc]init];
        [userContentController addScriptMessageHandler:self name:@"WXPay"]; // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        configuration.suppressesIncrementalRendering = YES;                 // 是否支持记忆读取
        configuration.userContentController = userContentController;        // 允许用户更改网页的设置

        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        //kvo 添加进度监控
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:WkwebBrowserContext];
        
        _wkWebView.allowsBackForwardNavigationGestures = YES;        //开启手势触摸
        [_wkWebView sizeToFit];                                      //适应你设定的尺寸
    }
    return _wkWebView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        self.title = change[@"new"];
    }
}


@end
