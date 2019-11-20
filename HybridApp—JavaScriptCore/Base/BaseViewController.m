//
//  BaseViewController.m
//  tangmall
//
//  Created by OrangeLife on 16/6/20.
//  Copyright © 2016年 Shenme Studio. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

//#import "LoginViewController.h"
#import "UrlMainViewController.h"
//#import "SettingViewController.h"
//
//#import <MJRefresh/MJRefresh.h>
//#import "SaveService.h"
//#import "Reachability.h"
//#import "NotReachableView.h"

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BaseViewController ()<UIAlertViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) NSString *alertCallback;
@property (strong, nonatomic) NSString *actionSheetCallback;
//@property (nonatomic, strong) NotReachableView * notReachableView;
@property (nonatomic, strong) NSString *urlStr;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /*全局背景 自动布局*/
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    /*背景色*/
    [self.view setBackgroundColor:[UIColor whiteColor]];
    /*导航条标题颜色*/
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : UIColorFromHex(0x363636),
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17]
                                                                      }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_isHideNav];
}

#pragma mark url解析
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 判断是否有网络
//    Reachability *reachability = [Reachability reachabilityWithHostName:self.urlStr];
//
//    if ([reachability currentReachabilityStatus] == NotReachable) {
//        if (self.notReachableView == nil) {
//            self.notReachableView = [[NotReachableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) withReloadBtnTarget:self action:@selector(reloadRequsetBtn)];
//            [self.view addSubview:self.notReachableView];
//        }
//    }else {
//        if (self.notReachableView != nil) {
//            [self.notReachableView removeFromSuperview];
//            self.notReachableView = nil;
//        }
//    }
    
    self.urlStr = [NSString stringWithFormat:@"%@",request.URL];
    
    //禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSString *urlString = [[request URL] absoluteString];
    if ([urlString hasPrefix:@"tangmall://"])
    {
        NSString *cmd = request.URL.host;
        if ([cmd isEqualToString:@"login"])
        {
            [self toLogin];
        }
        return NO;
    }
    return YES;
}

#pragma mark -- 加载失败重新刷新
- (void)reloadRequsetBtn
{
    [self refresh];
}

#pragma mark -- 开始加载调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [[SMProgressHUD shareInstancetype] showLoading];
}

#pragma mark 加载完成后注入js
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"app"] = self;
    
//    [[SMProgressHUD shareInstancetype] dismissLoadingView];
}

- (void)dealloc
{
    _webView.delegate = nil;
    [_webView stopLoading];
}

#pragma mark -- 加载失败调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"====%@",error);
//    [[SMProgressHUD shareInstancetype] dismissLoadingView];
}

#pragma mark js代码执行
- (void)toExecuteJavaScript:(NSString *)javaScript webView:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:javaScript];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self toExecuteJavaScript:[NSString stringWithFormat:_alertCallback, @(buttonIndex)] webView:_webView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self toExecuteJavaScript:[NSString stringWithFormat:_actionSheetCallback, @(buttonIndex)] webView:_webView];
}

- (void)setWebView:(UIWebView *)webView
{
    _webView = webView;
    [webView setBackgroundColor:[UIColor whiteColor]];
    [webView setDelegate:self];
    // webView添加刷新
//    [webView.scrollView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [_webView reload];
//        [_webView.scrollView.mj_header endRefreshing];
//    }]];
}

#pragma mark - App JavaScript Func
#pragma mark push
- (void)push:(NSString *)title url:(NSString *)url
{
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            UrlMainViewController *control = [[UrlMainViewController alloc]init];
            if (title != nil || [title isEqualToString:@""] == NO) {
                [control setTitle:title];
            }
            else
            {
                [control setIsHideNav:YES];
            }
            [control setUrlString:url];
            [control setDelegate:self];
            [self.navigationController pushViewController:control animated:YES];
        });
    }
    else if ([url hasPrefix:@"pluslife://"])
    {
        NSURL *changeUrl = [NSURL URLWithString:url];
        NSString *mode = @"";
        NSArray *querys = [changeUrl.query componentsSeparatedByString:@"&"];
        
        if ([changeUrl.query containsString:@"mode"]) {
            mode = querys[0];
            mode = [mode substringWithRange:NSMakeRange(5, 1)];
            
            if ([mode isEqualToString:@"1"]) {
                //跳转登录
                [self toLogin];
                
            }
            else if ([mode isEqualToString:@"2"])
            {
                //跳转设置
                dispatch_async(dispatch_get_main_queue(), ^(void){
//                    SettingViewController *settingControl = [SettingViewController new];
//                    [self.navigationController pushViewController:settingControl animated:YES];
                });
            }
        }
    }
}

#pragma mark 登录
- (void)toLogin
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [SaveService setObject:@"" forKey:AccessToken];
//        LoginViewController *loginControl = [LoginViewController new];
//        [self.navigationController pushViewController:loginControl animated:YES];
    });
}

#pragma mark 获取accesstoken
//- (NSString *)getAccessToken
//{
//    NSString *str = [SaveService objectForKey:AccessToken];
//    return str;
//}

#pragma mark 推出
- (void)pop
{
    if (_isRefresh)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refresh)])
        {
            [self.delegate refresh];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark 退出到底部视图
- (void)popToRoot
{
    if (_isRefresh)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refresh)])
        {
            [self.delegate refresh];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

#pragma mark 显示alert
- (void)showAlertViewWithTitle:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle callback:(NSString *)callback
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        _alertCallback = callback;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:sureTitle, nil];
        [alertView show];
    });
    
    
}

- (void)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle callback:(NSString *)callback
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        _actionSheetCallback = callback;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitle, nil];
        [actionSheet showInView:self.view];
    });
}

#pragma mark 显示Tip
- (void)showTip:(NSString *)tip
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:tip delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}

#pragma mark push
- (void)pushWithUrl:(NSString *)url
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UrlMainViewController *control = [UrlMainViewController new];
        [control setUrlString:url];
        [control setDelegate:self];
        [control setIsHideNav:YES];
        [self.navigationController pushViewController:control animated:YES];
    });
}

#pragma mark 设置是否刷新原来界面
- (void)setIsRefresh:(BOOL)isRefresh
{
    _isRefresh = isRefresh;
}

#pragma mark 刷新当前界面
- (void)refresh
{
    [_webView reload];
}

#pragma mark -- 将数据写入到本地
- (void)setWebCash:(NSString *)key value:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- 获取写入本地的数据
- (NSString *)getWebCash:(NSString *)key
{
    NSString *valueStr = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    if (valueStr == nil) {
        return @"";
    }
    return valueStr;
}

#pragma mark -- 禁止webView下拉刷新
- (void)stopSwipeRefresh
{
    _webView.scrollView.bounces = NO;
}

@end












