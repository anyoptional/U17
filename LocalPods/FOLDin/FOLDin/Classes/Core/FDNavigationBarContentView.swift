//
//  FDNavigationBarContentView.swift
//  FOLDin
//
//  Created by Archer on 2018/12/10.
//

import UIKit

class FDNavigationBarContentView: UIView {
    
    var contentInsets = FDEdgeInsets(left: 12, right: 12)
    
    private var navigationItem = FDNavigationItem()
    private var titleTextAttributes: [NSAttributedString.Key : Any]?
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.textAlignment = .center
        v.font = .boldSystemFont(ofSize: 18)
        v.lineBreakMode = .byTruncatingMiddle
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
    
    private lazy var backBarButtonItem: FDBarButtonItem = {
        let item = FDBarButtonItem()
        item.title = "返回"
        item.target = self
        item.action = #selector(_backAction)
        item.image = UIImage(nameInBundle: "img_back")
        addSubview(item.buttonView)
        return item
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
        var safeAreaInsetsLeft = contentInsets.left
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
        var safeAreaInsetsRight = contentInsets.right
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
        if titleView.width <= 0 {
            titleView.width = titleView.intrinsicContentSize.width
        }
        if titleView.height <= 0 {
            titleView.height = titleView.intrinsicContentSize.height
        }
        titleView.centerY = height / 2
        titleView.centerX = width / 2
        
        let leftWidth = leftBarStackView.right + (leftBarStackView.isHidden ? 0 : navigationItem.titleMargins.left)
        let rightOriginX = rightBarStackView.left - (rightBarStackView.isHidden ? 0 : navigationItem.titleMargins.right)
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
            debugPrint("WRANING: All UI element in FDNavigationBar exceeds the width limit.")
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
        if let title = navigationItem.title {
            titleTextAttributes = attributes
            titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        }
    }
}
