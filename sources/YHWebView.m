//
//  YHWebView.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/17.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHWebView.h"

static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface YHWebViewConfiguration :WKWebViewConfiguration


@end


@implementation YHWebViewConfiguration

- (instancetype)init {
    if(self = [super init]) {
        [self configuration];
    }
    return self;
}

- (void)configuration {
    self.allowsAirPlayForMediaPlayback = YES;//允许视频播放
    self.allowsInlineMediaPlayback = YES;    // 允许在线播放
    self.selectionGranularity = YES;         // 允许可以与网页交互，选择视图
    
    self.processPool = [[WKProcessPool alloc] init]; // web内容处理池
    
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    self.suppressesIncrementalRendering = YES;                 // 是否支持记忆读取
    self.userContentController = userContentController;        // 允许用户更改网页的设置
}


@end

@interface YHWebView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@end

@implementation YHWebView

#pragma mark -- init

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame configuration:[YHWebViewConfiguration new]];
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (self = [super initWithFrame:frame configuration:configuration]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.navigationDelegate = self;
    self.UIDelegate = self;
    //kvo 添加进度监控
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:WkwebBrowserContext];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
    self.allowsBackForwardNavigationGestures = YES;        //开启手势触摸
    [self sizeToFit];
    
    [self.configuration.userContentController addScriptMessageHandler:self name:@"uploadImageFromIOS"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))]) {
        NSString *newTitle = change[@"new"];
        if (self.observer) {
            self.observer(@{@"title":newTitle});
        }
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]) {
        float progress = self.estimatedProgress;
        if (self.observer) {
            self.observer(@{@"progress":@(progress)});
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -- WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.didFinish) {
        self.didFinish(webView);
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",message);
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

@end
