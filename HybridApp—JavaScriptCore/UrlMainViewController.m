//
//  UrlMainViewController.m
//  tangmall
//
//  Created by OrangeLife on 16/6/20.
//  Copyright © 2016年 Shenme Studio. All rights reserved.
//

#import "UrlMainViewController.h"

@interface UrlMainViewController ()

@end

@implementation UrlMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /*浏览器*/
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView setDelegate:self];
    [self.view addSubview:webView];
//    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    self.webView = webView;
    
}



@end
