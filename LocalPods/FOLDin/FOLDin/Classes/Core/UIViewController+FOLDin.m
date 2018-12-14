//
//  UIViewController+FOLDin.m
//  FOLDin
//
//  Created by Archer on 2018/12/12.
//  Copyright © 2018年 Archer. All rights reserved.
//

#import <objc/runtime.h>
#import <FOLDin/FOLDin-Swift.h>
#import "UIViewController+FOLDin.h"

static const char kFDNavigationBarContext = '0';
static const char kFDNavigationItemContext = '0';
static const char kFDNavigationBarHiddenContext = '0';
static const CGFloat kFDFixedStatusBarHeight = 20.0;
static const CGFloat kFDFixedPortraitNavigationBarHeight = 44.0;
static const CGFloat kFDFixedLandscapeNavigationBarHeight = 32.0;

@implementation UIViewController (FOLDin)

#pragma mark - Properties

- (FDNavigationBar *)fd_navigationBar {
    FDNavigationBar *navBar = objc_getAssociatedObject(self, &kFDNavigationBarContext);
    if (!navBar) {
        navBar = FDNavigationBar.new;
        objc_setAssociatedObject(self, &kFDNavigationBarContext, navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return navBar;
}

- (FDNavigationItem *)fd_navigationItem {
    FDNavigationItem *navItem = objc_getAssociatedObject(self, &kFDNavigationItemContext);
    if (!navItem) {
        navItem = FDNavigationItem.new;
        // Use key-value coding to access
        [navItem setValue:self.fd_navigationBar forKeyPath:@"delegate"];
        objc_setAssociatedObject(self, &kFDNavigationItemContext, navItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return navItem;
}

- (void)setFd_hidesSystemNavigationBar:(BOOL)fd_hidesSystemNavigationBar {
    objc_setAssociatedObject(self, &kFDNavigationBarHiddenContext, @(fd_hidesSystemNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fd_hidesSystemNavigationBar {
    NSNumber *hidesSystemNavigationBar = objc_getAssociatedObject(self, &kFDNavigationBarHiddenContext);
    if (hidesSystemNavigationBar == nil) {
        return YES;
    }
    return [hidesSystemNavigationBar boolValue];
}

#pragma mark - Caculations

- (BOOL)fd_isNavigationBarEnabled {
    return self.prefersNavigationBarStyle == UINavigationBarStyleCustom;
}

- (CGFloat)fd_navbarTop {
    CGFloat statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat safeAreaInsetsTop = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetsTop = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
    }
    UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
    CGFloat fixedStatusBarHeight = isPortrait ? kFDFixedStatusBarHeight : 0;
    return statusBarHeight > 0 ? statusBarHeight : (safeAreaInsetsTop > 0 ? safeAreaInsetsTop : fixedStatusBarHeight);
}

- (CGFloat)fd_navbarHeight {
    UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(orientation);
    return isPortrait ? kFDFixedPortraitNavigationBarHeight :
    (UIApplication.sharedApplication.statusBarHidden ?
     kFDFixedPortraitNavigationBarHeight : kFDFixedLandscapeNavigationBarHeight);
}

- (CGFloat)fd_fullNavbarHeight {
    return [self fd_navbarTop] + [self fd_navbarHeight];
}

@end

@implementation UIViewController (FDConfiguration)

- (void)fd_setNavigationBarHidden:(BOOL)animated {
    if ([self fd_isNavigationBarEnabled] && [self fd_hidesSystemNavigationBar]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)fd_layoutNavigationBar {
    CGFloat x = 0;
    CGFloat y = [self fd_navbarTop];
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat height = [self fd_navbarHeight];
    self.fd_navigationBar.frame = CGRectMake(x, y, width, height);
    [self.view insertSubview:self.fd_navigationBar atIndex:NSIntegerMax];
}

@end

@implementation UIViewController (FDLifeCycle)

+ (void)load {
    // Do this in main thread only
    dispatch_async(dispatch_get_main_queue(), ^{
        // All methods that affect fake bar
        SEL selectors[] = {
            @selector(viewDidLoad),
            @selector(viewWillAppear:),
            @selector(viewDidLayoutSubviews)
        };
        
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([NSString stringWithFormat:@"fd_%s", sel_getName(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)fd_viewDidLoad {
    [self fd_viewDidLoad];
    
    if ([self fd_isNavigationBarEnabled]) {
        [self fd_layoutNavigationBar];
    }
}

- (void)fd_viewWillAppear:(BOOL)animated {
    [self fd_viewWillAppear:animated];
    
    [self fd_setNavigationBarHidden:animated];
}

- (void)fd_viewDidLayoutSubviews {
    [self fd_viewDidLayoutSubviews];
    
    if ([self fd_isNavigationBarEnabled]) {
        [self fd_layoutNavigationBar];
    }
}

@end


