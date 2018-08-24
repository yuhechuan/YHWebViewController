//
//  YHProcessPool.h
//  YHWebViewController
//
//  Created by ruaho on 2018/8/24.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface YHProcessPool : WKProcessPool

+ (instancetype)sharedInstance;

@end
