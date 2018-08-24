//
//  YHWebConfiguration.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/21.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHWebConfiguration.h"

@implementation YHWebConfiguration

+ (instancetype)sharedInstance {
    static YHWebConfiguration *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YHWebConfiguration alloc] init];
    });
    return instance;
}

@end
