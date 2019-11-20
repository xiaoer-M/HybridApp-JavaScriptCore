//
//  BaseNavViewController.m
//  tangmall
//
//  Created by OrangeLife on 16/6/20.
//  Copyright © 2016年 Shenme Studio. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count != 0)
    {
        [viewController setHidesBottomBarWhenPushed:YES];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"base.bundle/back"] style:UIBarButtonItemStyleDone target:viewController action:@selector(pop)];
        [viewController.navigationItem setLeftBarButtonItem:backItem];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)pop {
    [self popViewControllerAnimated:YES];
}

@end
