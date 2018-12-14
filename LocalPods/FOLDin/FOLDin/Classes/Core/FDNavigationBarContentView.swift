//
//  FDNavigationBarContentView.swift
//  FOLDin
//
//  Created by Archer on 2018/12/10.
//

import UIKit

class FDNavigationBarContentView: UIView {
    
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
        addSubview(v)
        return v
    }()
    
    private lazy var rightBarStackView: FDButtonBarStackView = {
        let v = FDButtonBarStackView()
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
        var safeAreaInsetsLeft: CGFloat = 12
        if #available(iOS 11.0, *) {
            safeAreaInsetsLeft += safeAreaInsets.right
        }
        let vc = viewController
        if !navigationItem.hidesBackButton && // 没有隐藏
            vc !== vc?.navigationController?.children.first && // 不是根控制器
            (navigationItem.leftItemsSupplementBackButton || // 一直显示返回按钮
                (!navigationItem.leftItemsSupplementBackButton &&  // 不一直显示返回按钮但是没有设置左侧按钮
                    navigationItem.leftBarButtonItem == nil )) {
            backBarButtonItem.buttonView.isHidden = false
            backBarButtonItem.buttonView.size = backBarButtonItem.buttonView.intrinsicContentSize
            backBarButtonItem.buttonView.centerY = height / 2
            backBarButtonItem.buttonView.left = safeAreaInsetsLeft
        } else {
            backBarButtonItem.buttonView.isHidden = true
        }
    }
    
    private func _layoutLeftBarStackView() {
        var safeAreaInsetsLeft: CGFloat = 12
        if #available(iOS 11.0, *) {
            safeAreaInsetsLeft += safeAreaInsets.right
        }
        if let leftBarItems = navigationItem.leftBarButtonItems, !leftBarItems.isEmpty {
            leftBarStackView.subviews.forEach { $0.removeFromSuperview() }
            leftBarStackView.isHidden = false
            
            leftBarStackView.height = height
            
            var stackViewWidth: CGFloat = 0
            for leftBarItem in leftBarItems {
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
                stackViewWidth += 12
            }
            
            leftBarStackView.top = 0
            leftBarStackView.width = stackViewWidth - 12
            if !backBarButtonItem.buttonView.isHidden {
                leftBarStackView.left = backBarButtonItem.buttonView.right + 12
            } else {
                leftBarStackView.left = safeAreaInsetsLeft
            }
        } else {
            leftBarStackView.isHidden = true
        }
    }
    
    private func _layoutRightBarStackView() {
        var safeAreaInsetsRight: CGFloat = 12
        if #available(iOS 11.0, *) {
            safeAreaInsetsRight += safeAreaInsets.right
        }
        if let rightBarItems = navigationItem.rightBarButtonItems?.reversed(), !rightBarItems.isEmpty {
            rightBarStackView.subviews.forEach { $0.removeFromSuperview() }
            rightBarStackView.isHidden = false
            
            rightBarStackView.height = height
            
            var stackViewWidth: CGFloat = 0
            for rightBarItem in rightBarItems {
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
                stackViewWidth += 12
            }
            
            rightBarStackView.top = 0
            rightBarStackView.width = stackViewWidth - 12
            rightBarStackView.right = width - safeAreaInsetsRight
            
        } else {
            rightBarStackView.isHidden = true
        }
    }
    
    private func _layoutNavigationTitleView() {
        titleTextAttributesDidChange(titleTextAttributes)
        titleLabel.isHidden = navigationItem.titleView != nil
        let titleView = (navigationItem.titleView != nil) ? navigationItem.titleView! : titleLabel
        if titleView.width == 0 {
            titleView.width = titleView.intrinsicContentSize.width
        }
        if titleView.height == 0 {
            titleView.height = titleView.intrinsicContentSize.height
        }
        titleView.left = leftBarStackView.right + 12
        titleView.centerY = height / 2
    }
}

extension FDNavigationBarContentView {
    @objc private func _backAction() {
        guard let vc = viewController else { return }
        if let navVc = vc.navigationController {
            navVc.popViewController(animated: true)
        } else {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}

extension FDNavigationBarContentView {
    func navigationItemDidChange(_ item: FDNavigationItem) {
        debugPrint("navigationItemChanged")
        
        layer.masksToBounds = true

        if let newTitleView = item.titleView {
            if let oldTitleView = navigationItem.titleView {
                oldTitleView.removeFromSuperview()
            }
            addSubview(newTitleView)
        }
        navigationItem = item
    }
    
    func titleTextAttributesDidChange(_ attributes: [NSAttributedString.Key : Any]?) {
        if let title = navigationItem.title {
            titleTextAttributes = attributes
            titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        }
    }
}
