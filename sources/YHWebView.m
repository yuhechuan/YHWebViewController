//
//  YHWebView.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/17.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHWebView.h"
#import "YHPlugin.h"
#import "YHProcessPool.h"

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.mediaPlaybackRequiresUserAction = YES;
#pragma clang diagnostic pop
    self.processPool = [YHProcessPool sharedInstance]; // web内容处理池
    
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    self.suppressesIncrementalRendering = YES;                 // 是否支持记忆读取
    self.userContentController = userContentController;        // 允许用户更改网页的设置
}


@end

@interface YHWebView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *webPageFromWho;                  // 网页由谁提供

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
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.navigationDelegate = self;
    self.UIDelegate = self;
    //kvo 添加进度监控
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:WkwebBrowserContext];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
    self.allowsBackForwardNavigationGestures = YES;        //开启手势触摸
    [self sizeToFit];
    [self addScriptClassName];
}

- (void)setFromController:(UIViewController *)fromController {
    _fromController = fromController;
    [self setupWebPageFromInformation];
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

- (void)addScriptClassName {
    NSArray *plugins = [[YHPlugin sharedInstance] loadPlugin];
    for (NSString *className in plugins) {
        NSString *str = className;
        if ([className containsString:@":"]) {
            str = [className stringByReplacingOccurrencesOfString:@":" withString:@""];
        }
        [self.configuration.userContentController addScriptMessageHandler:self name:str];
    }
}

- (void)reloadCookie:(WKWebView *)webView
    navigationAction:(WKNavigationAction *)navigationAction {
    NSMutableURLRequest *newRequest = [navigationAction.request mutableCopy];
    NSMutableArray *array = [NSMutableArray array];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:navigationAction.request.URL]) {
        NSString *value = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
        [array addObject:value];
    }
    
    NSString *cookie = [array componentsJoinedByString:@";"];
    [newRequest setValue:cookie forHTTPHeaderField:@"Cookie"];
    [webView loadRequest:newRequest];
}

- (void)setupWebPageFromInformation {
    CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
    float heightPadding = statusBarViewRect.size.height;
    if (self.fromController.navigationController) {
        heightPadding = statusBarViewRect.size.height + self.fromController.navigationController.navigationBar.frame.size.height;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.webPageFromWho];
    [keyWindow bringSubviewToFront:self.webPageFromWho];
    CGFloat totalWith = [UIScreen mainScreen].bounds.size.width;
    self.webPageFromWho.frame = CGRectMake(5,64 + 10 ,totalWith - 2 *5 ,20);
}


- (void)yh_webView:(WKWebView *)webView didFinishNavigationAction:(WKNavigationAction *)navigationAction {
    NSURLRequest *request = navigationAction.request;
    if (request.URL.host) {
        NSNumber *port = request.URL.port;
        if (port) {
            self.webPageFromWho.text = [NSString stringWithFormat:@"网页由 %@:%@ 提供", request.URL.host, port];
        } else {
            self.webPageFromWho.text = [NSString stringWithFormat:@"网页由 %@ 提供", request.URL.host];
        }
    }
}


- (UILabel *)webPageFromWho {
    if (!_webPageFromWho) {
        _webPageFromWho = [[UILabel alloc] init];
        _webPageFromWho.numberOfLines = 2;
        _webPageFromWho.textColor = [UIColor grayColor];
        _webPageFromWho.textAlignment = NSTextAlignmentCenter;
        _webPageFromWho.font = [UIFont systemFontOfSize:12];
        _webPageFromWho.alpha = 0;
    }
    return _webPageFromWho;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y < -94) {
        CGFloat offsety = - 94 - y;
        float sale = offsety / 60;
        self.webPageFromWho.alpha = sale;
    } else {
        self.webPageFromWho.alpha = 0;
    }
}

#pragma mark - WKNavigationDelegate 页面加载
#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.callBack) {
        self.callBack(YHWebViewDidStart, webView, nil);
    }
}

#pragma mark 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.callBack) {
        self.callBack(YHWebViewDidCommit, webView, nil);
    }
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    if (self.callBack) {
        self.callBack(YHWebViewDidFinish, webView, nil);
    }
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.callBack) {
        self.callBack(YHWebViewDidFail, webView, error);
    }
}


#pragma mark - WKNavigationDelegate 页面跳转

#pragma mark 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self yh_webView:webView didFinishNavigationAction:navigationAction];
    if (self.callBack) {
        self.callBack(YHWebViewDecidePolicyAction, webView, nil);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark 身份验证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    if (self.callBack) {
        self.callBack(YHWebViewDidReceiveAuthentication, webView, nil);
    }
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

#pragma mark 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (self.callBack) {
        self.callBack(YHWebViewDecidePolicyResponse, webView, nil);
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.callBack) {
        self.callBack(YHWebViewDidReceiveServerRedirect, webView, nil);
    }
}

#pragma mark WKNavigation导航错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.callBack) {
        self.callBack(YHWebViewDidReceiveServerRedirect, webView, error);
    }
}

#pragma mark WKWebView终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    if (self.callBack) {
        self.callBack(YHWebViewDidTerminate, webView, nil);
    }
    // 白屏问题  ios9 以上
    [self reload];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler(); }]];
    UIViewController *present = [[UIApplication sharedApplication].keyWindow rootViewController];
    if (present){
        [present presentViewController:alertController animated:YES completion:^{}];
    } else {
        completionHandler();
    }
}

#pragma mark WKScriptMessageHandler 终止
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    id arguments = message.body;
    NSString *methodName = message.name;
    [[YHPlugin sharedInstance] execute:methodName
                             arguments:arguments];
}

- (void)dealloc {
    [self.webPageFromWho removeFromSuperview];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

@end
