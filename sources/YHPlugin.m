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

@implementation YHPlugin




- (NSArray <NSString *>*)_method_list:(NSString *)target_name {
    Class target_class = NSClassFromString(target_name);
    unsigned int _count = 0;
    Method *method_list = class_copyMethodList(target_class, &_count);
    NSMutableArray *methods = [NSMutableArray arrayWithCapacity:_count];
    for (int i = 0; i < _count; i ++) {
        SEL temp_sel = method_getName(method_list[i]);
        const char *temp_method_name = sel_getName(temp_sel);
        NSString *method_name = [NSString stringWithFormat:@"%s",temp_method_name];
        [methods addObject:method_name];
    }
    free(method_list);
    return methods;
}

@end
