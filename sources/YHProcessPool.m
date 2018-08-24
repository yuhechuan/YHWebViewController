//
//  YHProcessPool.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/24.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHProcessPool.h"

@implementation YHProcessPool

+ (instancetype)sharedInstance {
    static YHProcessPool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YHProcessPool alloc] init];
    });
    return instance;
}

@end
