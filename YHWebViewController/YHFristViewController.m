//
//  YHFristViewController.m
//  YHWebViewController
//
//  Created by ruaho on 2018/8/17.
//  Copyright © 2018年 ruaho. All rights reserved.
//

#import "YHFristViewController.h"
#import "YHButton.h"
#import "YHWebViewController.h"

@interface YHFristViewController ()

@property (nonatomic, strong) YHButton *display;
@property (nonatomic, strong) YHButton *displayPresent;

@end

@implementation YHFristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)setUp {
    self.title = @"项目演示";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = 200;
    CGFloat height = 50;
    CGFloat x = (self.view.bounds.size.width - width) / 2.0;
    CGFloat y1 = 200;
    _display = [[YHButton alloc]initWithFrame:CGRectMake(x, y1, width, height)];
    _display.title = @"演示Push";
    _display.buttonColor = [UIColor colorWithRed:70 / 225.0 green:187 / 255.0 blue:38 / 255.0 alpha:1];
    typeof(self) __weak weakSelf = self;
    _display.operation = ^{
        [weakSelf displayAnimation];
    };
    [self.view addSubview:_display];
    
    _displayPresent = [[YHButton alloc]initWithFrame:CGRectMake(x, y1+ height *2, width, height)];
    _displayPresent.title = @"演示Present";
    _displayPresent.buttonColor = [UIColor colorWithRed:230 / 225.0 green:103 / 255.0 blue:103 / 255.0 alpha:1];
    _displayPresent.operation = ^{
        [weakSelf displayAnimationPresent];
    };
    [self.view addSubview:_displayPresent];
}

- (void)displayAnimation {
    YHWebViewController *w = [[YHWebViewController alloc]init];
    w.openUrl = @"index";
    w.loadWebType = YHLoadWebTypeHTMLString;
    [self.navigationController pushViewController:w animated:YES];
}

- (void)displayAnimationPresent {
    YHWebViewController *w = [[YHWebViewController alloc]init];
    w.openUrl = @"https://www.baidu.com";
    UINavigationController *n = [[UINavigationController alloc]initWithRootViewController:w];
    [self presentViewController:n animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
