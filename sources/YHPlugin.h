//
//  YHPlugin.h
//  YHWebViewController
//
//  Created by ruaho on 2018/8/21.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHCommand : NSObject

@property (nonatomic, readonly) NSString *className;    // 插件实现类名
@property (nonatomic, readonly) NSString *methodName;   // 调用方法名
@property (nonatomic, readonly) id arguments;           // 调用参数
@property (nonatomic, readonly) NSString *callbackID;   // JS端回调函数ID

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
                       callbackID:(NSString *)callbackID;

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
                        arguments:(id)arguments;

/**
 *  JS调用Native端的参数封装
 *
 *  @param className   Native类名
 *  @param methodsName Native方法名
 *
 *  @return YHCommand
 */
- (instancetype)initWithClassName:(NSString *)className
                       methodName:(NSString *)methodsName;

@end

@interface YHPlugin : NSObject

+ (instancetype)sharedInstance;
/*
 * load plug-in
 */
- (NSArray *)loadPlugin;

/*
 * execute OC method
 */
- (void)execute:(NSString *)methodName
      arguments:(id)arguments;

@end
