//
//  YHWebConfiguration.h
//  YHWebViewController
//
//  Created by ruaho on 2018/8/21.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHWebConfiguration : NSObject

/*
 * a class to bridging OC and JS
 */
@property (nonatomic, copy) NSString *className;

+ (instancetype)sharedInstance;

@end
