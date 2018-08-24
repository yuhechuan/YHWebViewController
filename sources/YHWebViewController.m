//
//  YHWebViewController.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/2.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHWebViewController.h"
#import <WebKit/WebKit.h>
#import "YHWebViewProgress.h"

static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface YHWebViewController ()<UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic, strong) YHWebViewProgress *progressView;

@end

@implementation YHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebViewURL];
    [self addConfiguration];
    // Do any additional setup after loading the view.
}

- (void)addConfiguration {
    [self.view addSubview:self.wkWebView];
    [self.navigationController.navigationBar addSubview:self.progressView];
    [self configurationDelegate];
}

- (void)configurationDelegate {
    typeof(self) __weak weakSelf = self;
    self.wkWebView.observer = ^(NSDictionary *observer) {
        if (observer[@"title"]) {
            weakSelf.title = observer[@"title"];
        }
        if (observer[@"progress"] && weakSelf.allowRealProgress) {
            NSLog(@"%f",[observer[@"progress"] floatValue]);
            [weakSelf.progressView setProgress:[observer[@"progress"] floatValue]];
        }
    };
    self.wkWebView.callBack = ^(YHWebViewDelegate callBackType, WKWebView *webView, NSError *error) {
        if (callBackType == YHWebViewDidFinish) {
            [weakSelf.progressView setProgress:1.0];
        }
    };
}


- (void)configurationOC {
    [self.wkWebView evaluateJavaScript:@"btnClick()" completionHandler:nil];
}

- (void)loadWebViewURL {
    switch (self.loadWebType) {
        case YHLoadWebTypeURLString:{
            [self loadURLString];
            break;
        }
        case YHLoadWebTypeHTMLString:{
            [self loadHostPathURL:self.openUrl];
            break;
        }
        case YHLoadWebTypeHTMLLabel:{
            //self.needLoadJSPOST = YES;
            [self loadHTMLLabel:self.openUrl];
            break;
        }
        default:
            [self loadURLString];
            break;
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

- (void)loadHTMLLabel:(NSString *)html {
    [self.wkWebView loadHTMLString:html baseURL:nil];
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


- (YHWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[YHWebView alloc] initWithFrame:self.view.bounds];
    }
    return _wkWebView;
}

- (YHWebViewProgress *)progressView {
    if (!_progressView) {
        CGFloat progressBarHeight = 3.0;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [[YHWebViewProgress alloc] initWithFrame:barFrame];
        _progressView.progressColor = self.progressColor?:[UIColor colorWithRed:0 green:175/255.0 blue:255/255.0 alpha:1];
        if (!self.allowRealProgress) [_progressView displayStartAnimation];
    }
    return _progressView;
}

@end
