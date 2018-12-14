//
//  UIViewController+FOLDin.h
//  FOLDin
//
//  Created by Archer on 2018/12/12.
//  Copyright © 2018年 Archer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FDNavigationBar;
@class FDNavigationItem;

@interface UIViewController (FOLDin)

/**
 *  The navigation bar managed by the view controller.
 */
@property (nonatomic, readonly, strong) FDNavigationBar *fd_navigationBar NS_SWIFT_NAME(_namespace_navigationBar);

/**
 *  The navigation item used to represent the view controller's navigation bar.
 */
@property (nonatomic, readonly, strong) FDNavigationItem *fd_navigationItem NS_SWIFT_NAME(_namespace_navigationItem);

/**
 *  Hides system navigation bar when use FDNavigationBar, YES by default.
 *  NOTE: We hides system navigation bar in viewWillAppear method, so you
 *  should set thid property in before viewWillAppear.
 */
@property (nonatomic, assign) BOOL fd_hidesSystemNavigationBar NS_SWIFT_NAME(_namespace_hidesSystemNavigationBar);

/**
 *  Shortcut for `CGRectGetMaxY(fd_navigationBar.frame)`, helps to layout UI element.
 */
@property (nonatomic, readonly, assign) CGFloat fd_fullNavbarHeight NS_SWIFT_NAME(_namespace_fullNavbarHeight);

@end

NS_ASSUME_NONNULL_END
