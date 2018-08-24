//
//  YHPlugin.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/21.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHPlugin.h"
#import <objc/runtime.h>
#import "pthread.h"
#import "YHWebConfiguration.h"
#import "YHProxyRouter.h"

@implementation YHCommand

/**
 *  JS调用Native端的参数封装
 *
 *  @param className   Native类名
 *  @param methodsName Native方法名
 *  @param arguments   方法参数
 *  @param callbackID  JS端回调函数ID
 *
 *  @return YHCommand
 */
- (instancetype)initWithClassName:(NSString *)className
                       methodName:(NSString *)methodsName
                        arguments:(id)arguments
                       callbackID:(NSString *)callbackID {
    
    if (self = [super init]) {
        _className = className;
        _methodName = methodsName;
        _arguments = arguments;
        _callbackID = callbackID;
    }
    return self;
}

/**
 *  JS调用Native端的参数封装
 *
 *  @param className   Native类名
 *  @param methodsName Native方法名
 *  @param arguments   方法参数
 *
 *  @return YHCommand
 */
- (instancetype)initWithClassName:(NSString *)className
                       methodName:(NSString *)methodsName
                        arguments:(id)arguments {
    
    return [self initWithClassName:className
                        methodName:methodsName
                         arguments:arguments
                        callbackID:nil];
}

/**
 *  JS调用Native端的参数封装
 *
 *  @param className   Native类名
 *  @param methodsName Native方法名
 *
 *  @return YHCommand
 */
- (instancetype)initWithClassName:(NSString *)className
                       methodName:(NSString *)methodsName {
    
    return [self initWithClassName:className
                        methodName:methodsName
                         arguments:nil];
}

@end

@interface YHPlugin ()

@property (nonatomic, strong) YHProxyRouter *proxyRouter;

@end

@implementation YHPlugin

+ (instancetype)sharedInstance {
    static YHPlugin *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YHPlugin alloc] init];
    });
    return instance;
}

/*
 * load plug-in
 */
- (NSArray *)loadPlugin {
    NSArray *classNameList = [YHWebConfiguration sharedInstance].classNameList;
    if (classNameList.count == 0) {
        NSLog(@"ERROR，插件不存在");
        return @[];
    }
    self.proxyRouter = [YHProxyRouter initWithTargets:classNameList];
    return [self.proxyRouter methodNameList];
}


- (void)execute:(NSString *)methodName
      arguments:(id)arguments {
    NSString *className = [self.proxyRouter methodNameFromMethodName:methodName];
    YHCommand *command = [[YHCommand alloc]initWithClassName:className
                                                  methodName:methodName
                                                   arguments:arguments];
    [self.proxyRouter executeMethod:methodName param:command];
}



@end
