//
//  FDNavigationBarContentView.swift
//  FOLDin
//
//  Created by Archer on 2018/12/10.
//

import UIKit

class FDNavigationBarContentView: UIView {
    
    var contentMargin = FDMargin(left: 12, right: 12) {
        didSet { setNeedsLayout() }
    }
    
    private var navigationItem = FDNavigationItem()
    private var titleTextAttributes: [NSAttributedString.Key : Any]?
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.textAlignment = .center
        v.lineBreakMode = .byTruncatingTail
        v.font = .boldSystemFont(ofSize: 17)
        addSubview(v)
        return v
    }()
    
    private lazy var leftBarStackView: FDButtonBarStackView = {
        let v = FDButtonBarStackView()
        v.layer.masksToBounds = true
        addSubview(v)
        return v
    }()
    
    private lazy var rightBarStackView: FDButtonBarStackView = {
        let v = FDButtonBarStackView()
        v.layer.masksToBounds = true
        addSubview(v)
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _layoutBackButton()
        _layoutLeftBarStackView()
        _layoutRightBarStackView()
        _layoutNavigationTitleView()
    }
}

extension FDNavigationBarContentView {
    private func _layoutBackButton() {
        // back button 一定有 只是显不显示
        let backBarButtonItem: FDBarButtonItem
        if let backItem = navigationItem.backBarButtonItem {
            if backItem.target == nil && backItem.action == nil {
                backItem.target = self
                backItem.action = #selector(_backAction)
            }
            addSubview(backItem.buttonView)
            backBarButtonItem = backItem
        } else {
            let backItem = FDBarButtonItem()
            backItem.title = "返回"
            backItem.target = self
            backItem.action = #selector(_backAction)
            backItem.image = UIImage(nameInBundle: "img_back")
            addSubview(backItem.buttonView)
            backBarButtonItem = backItem
            navigationItem.backBarButtonItem = backItem
        }
        var safeAreaInsetsLeft = contentMargin.left
        if #available(iOS 11.0, *) {
            safeAreaInsetsLeft += safeAreaInsets.left
        }
        let vc = viewController
        backBarButtonItem.buttonView.left = safeAreaInsetsLeft
        if !navigationItem.hidesBackButton && // 没有隐藏
            vc !== vc?.navigationController?.children.first && // 不是根控制器
            (navigationItem.leftItemsSupplementBackButton || // 一直显示返回按钮
                (!navigationItem.leftItemsSupplementBackButton &&  // 不一直显示返回按钮但是没有设置左侧按钮
                    navigationItem.leftBarButtonItem == nil )) {
            backBarButtonItem.buttonView.isHidden = false
            backBarButtonItem.buttonView.size = backBarButtonItem.buttonView.intrinsicContentSize
        } else {
            backBarButtonItem.buttonView.size = .zero
            backBarButtonItem.buttonView.isHidden = true
        }
        backBarButtonItem.buttonView.centerY = height / 2
    }
    
    private func _layoutLeftBarStackView() {
        let backBarButtonItem = navigationItem.backBarButtonItem!
        leftBarStackView.top = 0
        leftBarStackView.height = height
        leftBarStackView.left = backBarButtonItem.buttonView.right
        if let leftBarItems = navigationItem.leftBarButtonItems, !leftBarItems.isEmpty {
            if !backBarButtonItem.buttonView.isHidden {
                leftBarStackView.left += leftBarItems[0].margin
            }
            leftBarStackView.subviews.forEach { $0.removeFromSuperview() }
            var stackViewWidth: CGFloat = 0
            for (index, leftBarItem) in leftBarItems.enumerated() {
                let view = (leftBarItem.customView != nil) ? leftBarItem.customView! : leftBarItem.buttonView
                view.left = stackViewWidth
                if view.width <= 0 {
                    view.width = view.intrinsicContentSize.width
                }
                stackViewWidth += view.width
                if view.height <= 0 {
                    view.height = view.intrinsicContentSize.height
                }
                view.centerY = leftBarStackView.height / 2
                leftBarStackView.addSubview(view)
                if index + 1 < leftBarItems.count {
                    stackViewWidth += leftBarItems[index + 1].margin
                }
            }
            leftBarStackView.width = stackViewWidth
            leftBarStackView.isHidden = false
        } else {
            leftBarStackView.width = 0
            leftBarStackView.isHidden = true
        }
    }
    
    private func _layoutRightBarStackView() {
        var safeAreaInsetsRight = contentMargin.right
        if #available(iOS 11.0, *) {
            safeAreaInsetsRight += safeAreaInsets.right
        }
        rightBarStackView.top = 0
        rightBarStackView.height = height
        if let rightBarButtonItems = navigationItem.rightBarButtonItems?.reversed(), !rightBarButtonItems.isEmpty {
            let rightBarItems = Array(rightBarButtonItems)
            rightBarStackView.subviews.forEach { $0.removeFromSuperview() }
            var stackViewWidth: CGFloat = 0
            for (index, rightBarItem) in rightBarItems.enumerated() {
                let view = (rightBarItem.customView != nil) ? rightBarItem.customView! : rightBarItem.buttonView
                view.left = stackViewWidth
                if view.width <= 0 {
                    view.width = view.intrinsicContentSize.width
                }
                stackViewWidth += view.width
                if view.height <= 0 {
                    view.height = view.intrinsicContentSize.height
                }
                view.centerY = rightBarStackView.height / 2
                rightBarStackView.addSubview(view)
                if index + 1 < rightBarItems.count {
                    stackViewWidth += rightBarItems[index + 1].margin
                }
            }
            rightBarStackView.isHidden = false
            rightBarStackView.width = stackViewWidth
        } else {
            rightBarStackView.isHidden = true
            rightBarStackView.width = 0
        }
        rightBarStackView.right = width - safeAreaInsetsRight
    }
    
    private func _layoutNavigationTitleView() {
        titleTextAttributesDidChange(titleTextAttributes)
        titleLabel.isHidden = navigationItem.titleView != nil
        let titleView = (navigationItem.titleView != nil) ? navigationItem.titleView! : titleLabel
        // 对于leftBarButtonItems和rightBarButtonItems肯定是要显示完全的
        // 唯一可以截断的就是titleView 在发生屏幕旋转时，因为navigationBar
        // 变长了，所以可以试着去调整titleView的大小
        if titleView.width <= 0 || titleView.width < titleView.intrinsicContentSize.width {
            titleView.width = titleView.intrinsicContentSize.width
        }
        if titleView.height <= 0 || titleView.width < titleView.intrinsicContentSize.height {
            titleView.height = titleView.intrinsicContentSize.height
        }
        titleView.centerY = height / 2
        titleView.centerX = width / 2
        
        // 只有当backButton和leftBarStackView都没有时才不计算navigationItem.titleViewMargin.left
        let backBarButtonItem = navigationItem.backBarButtonItem!
        let leftWidth = leftBarStackView.right + (leftBarStackView.isHidden && backBarButtonItem.buttonView.isHidden ? 0 : navigationItem.titleViewMargin.left )
        let rightOriginX = rightBarStackView.left - (rightBarStackView.isHidden ? 0 : navigationItem.titleViewMargin.right)
        let rightWidth = width - rightOriginX
        let remainingWidth = width - leftWidth - rightWidth
        if remainingWidth >= titleView.width {
            // 可以居中放置
            if titleView.left >= leftWidth && titleView.right <= rightOriginX {
                titleView.centerX = width / 2
            } else if leftWidth >= rightWidth {
                titleView.left = leftWidth
            } else if rightWidth > leftWidth {
                titleView.right = rightOriginX
            } else {
                debugPrint("WRANING: What the fuck?!")
            }
        } else {
            // 还有空间可以放titleView
            // 但是满足不了宽度要求就采取截断
            if leftWidth < rightOriginX {
                titleView.width = rightOriginX - leftWidth
                titleView.right = rightOriginX
            } else {
                titleView.width = 0
                let extraPart = abs(rightOriginX - leftWidth)
                let appropriateValue = (extraPart - navigationItem.titleViewMargin.left - navigationItem.titleViewMargin.right + 12) / 2
                let oldLeftBarStackViewLeft = leftBarStackView.left
                leftBarStackView.width -= appropriateValue
                leftBarStackView.left = oldLeftBarStackViewLeft
                let oldRightBarStackViewRight = rightBarStackView.right
                rightBarStackView.width -= appropriateValue
                rightBarStackView.right = oldRightBarStackViewRight
                debugPrint("WRANING: All UI element in FDNavigationBar exceeds the width limit.")
            }
        }
    }
}

extension FDNavigationBarContentView {
    @objc private func _backAction() {
        guard let vc = viewController else { return }
        if let navVc = vc.navigationController {
            navVc.popViewController(animated: true)
        } else if vc.presentingViewController != nil {
            vc.dismiss(animated: true, completion: nil)
        } else {
            debugPrint("WRANING: Can not figure out how `\(vc)` is showed, this tap will be a no-op.")
        }
    }
}

extension FDNavigationBarContentView {
    func navigationItemDidChange(_ item: FDNavigationItem) {
        layer.masksToBounds = true
        if let newTitleView = item.titleView {
            if let oldTitleView = navigationItem.titleView {
                oldTitleView.removeFromSuperview()
            }
            addSubview(newTitleView)
        }
        navigationItem = item
        // 根据新数据重新布局
        setNeedsLayout()
    }
    
    func titleTextAttributesDidChange(_ attributes: [NSAttributedString.Key : Any]?) {
        titleTextAttributes = attributes
        guard let title = navigationItem.title else {
            titleLabel.attributedText = nil
            return
        }
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
    }
}
