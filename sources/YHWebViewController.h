//
//  YHWebViewController.h
//  YHWebViewController
//
//  Created by ruaho on 2018/8/2.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YHLoadWebType) {
    YHLoadWebTypeURLString = 1,//内容
    YHLoadWebTypeHTMLString,//标签
    YHLoadWebTypePOSTString//内容和标签
};

@interface YHWebViewController : UIViewController

/*
 * 加载类型 默认是YHLoadWebTypeURLString
 */
@property (nonatomic, assign) YHLoadWebType loadWebType;

/*
 * 加载url
 */
@property (nonatomic, copy) NSString *openUrl;


@end
