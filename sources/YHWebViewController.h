//
//  YHWebViewController.h
//  YHWebViewController
//
//  Created by ruaho on 2018/8/2.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YHLoadWebType) {
    YHLoadWebTypeURLString = 1, // 加载url
    YHLoadWebTypeHTMLString,    // 加载本地html文件
    YHLoadWebTypeHTMLLabel      // 加载html标签
};

@interface YHWebViewController : UIViewController

/*
 * load type default is YHLoadWebTypeURLString
 */
@property (nonatomic, assign) YHLoadWebType loadWebType;

/*
 * load url is necessary
 */
@property (nonatomic, copy) NSString *openUrl;

/*
 * A Boolean value indicating whether realProgress is allowed.default is NO
 */
@property (nonatomic, assign) BOOL allowRealProgress;

/*
 * progressView Color.   default is rgb (0,175,255,1)
 */
@property (nonatomic, strong) UIColor *progressColor;


@end
