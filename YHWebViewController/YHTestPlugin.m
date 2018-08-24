//
//  YHTestPlugin.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/24.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHTestPlugin.h"

@implementation YHTestPlugin

- (void)test:(YHCommand *)command {
    NSLog(@"%@",command.methodName);
}

@end
