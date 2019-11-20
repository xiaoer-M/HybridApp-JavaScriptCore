//
//  BaseViewController.h
//  tangmall
//
//  Created by OrangeLife on 16/6/20.
//  Copyright © 2016年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol AppJSExport <JSExport>
JSExportAs(push,- (void)push:(NSString *)title url:(NSString *)url);
JSExportAs(alert, - (void)showAlertViewWithTitle:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle callback:(NSString *)callback);
JSExportAs(actionSheet, - (void)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle callback:(NSString *)callback);
JSExportAs(setWebCash, - (void)setWebCash:(NSString *)key value:(NSString *)value);
- (void)toLogin;
- (NSString *)getAccessToken;
- (void)pop;
- (void)popToRoot;
- (void)showTip:(NSString *)tip;
- (void)pushWithUrl:(NSString *)url;
- (void)setIsRefresh:(BOOL)isRefresh;
- (void)refresh;
- (void)stopSwipeRefresh;
- (NSString *)getWebCash:(NSString *)key;

@end

@protocol AppBaseDelegate <NSObject>

@optional
- (void)refresh;
@end

@interface BaseViewController : UIViewController <UIWebViewDelegate,AppJSExport, AppBaseDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (assign, nonatomic) BOOL isHideNav;
@property (weak, nonatomic) id<AppBaseDelegate> delegate;
@property (assign, nonatomic) BOOL isRefresh;
#pragma mark 执行JS代码
/**
 *  @author Vaith, 16-06-20 16:06:35
 *
 *  执行js代码
 *
 *  @param javaScript js代码
  *  @param webView 页面
 */
- (void)toExecuteJavaScript:(NSString *)javaScript webView:(UIWebView *)webView;

#pragma mark - App JavaScript Func
#pragma mark push
/**
 *  @author Vaith, 16-06-22 18:06:16
 *
 *  push界面
 *
 *  @param title 标题
 *  @param url   url
 */
- (void)push:(NSString *)title url:(NSString *)url;

#pragma mark 跳出登录界面
/**
 *  @author Vaith, 16-06-20 14:06:03
 *
 *  跳出登录界面
 */
- (void)toLogin;

#pragma mark 获取登录信息
/**
 *  @author Vaith, 16-06-22 18:06:35
 *
 *  获取登录权限码
 *
 *  @return 权限吗
 */
- (NSString *)getAccessToken;

#pragma mark 推出
- (void)pop;

#pragma mark 推出到底部视图
/**
 *  @author Vaith, 16-06-28 10:06:52
 *
 *  退出到底部视图
 */
- (void)popToRoot;

#pragma mark 显示系统弹窗
/**
 *  @author Vaith, 16-06-28 10:06:33
 *
 *  AlertView
 *
 *  @param title       标题
 *  @param msg        内容
 *  @param cancelTitle 取消按钮标题
 *  @param sureTitle   确定按钮标题
 *  @param callback    回调方法func(%@)
 */
- (void)showAlertViewWithTitle:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle callback:(NSString *)callback;


#pragma mark action
/**
 *  @author Vaith, 16-06-28 10:06:05
 *
 *  actionsheet
 *
 *  @param title                  title
 *  @param cancelButtonTitle      取消按钮标题
 *  @param destructiveButtonTitle 确认按钮标题
 *  @param otherButtonTitle       其他标题按钮
 *  @param callback               回调func(%@)
 */
- (void)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle callback:(NSString *)callback;

#pragma mark tip
/**
 *  @author Vaith, 16-06-28 17:06:30
 *
 *  显示tipview
 *
 *  @param tip 提示内容
 */
- (void)showTip:(NSString *)tip;

/**
 *  @author Vaith, 16-06-28 17:06:47
 *
 *  push
 *
 *  @param url 链接
 */
- (void)pushWithUrl:(NSString *)url;

/**
 *  @author Vaith, 16-06-28 17:06:26
 *
 *  设置是否刷新原来界面
 *
 *  @param isRefresh <#isRefresh description#>
 */
- (void)setIsRefresh:(BOOL)isRefresh;

/**
 *  将数据写入本地缓存
 *
 *  @param key   键
 *  @param value 值
 */
- (void)setWebCash:(NSString *)key value:(NSString *)value;

/**
 *  获取本地数据
 *
 *  @param key 键
 *
 *  @return 返回值
 */
- (NSString *)getWebCash:(NSString *)key;

/**
 *  禁止webView下拉刷新
 */
- (void)stopSwipeRefresh;

@end






