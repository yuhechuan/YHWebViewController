//
//  YHTestPlugin.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/24.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHTestPlugin.h"
#import <UIKit/UIKit.h>

@implementation YHTestPlugin

- (void)test:(YHCommand *)command {
    NSLog(@"%@",command.methodName);
    [self showError:(NSString *)command.arguments];
}

- (void)showError:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"这是一个OC控件" message:message preferredStyle:UIAlertControllerStyleAlert];
    //创建action 添加到alertController上 可根据UIAlertActionStyleDefault创建不通的alertAction
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:action];
    //呈现
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
    [vc presentViewController:alertController animated:YES completion:nil];
}

@end
