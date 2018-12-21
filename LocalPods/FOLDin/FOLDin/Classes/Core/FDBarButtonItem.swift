//
//  FDBarButtonItem.swift
//  FOLDin
//
//  Created by Archer on 2018/12/10.
//

import UIKit

@objc protocol FDBarButtonItemDelegate: NSObjectProtocol {
    func barButtonItemDidChange(_ item: FDBarButtonItem)
}

/// A wrapper around `UIButton`.
/// NOTE: 如果是customView，那它必须正确实现
/// intrinsicContentSize或者给定frame.size
@objcMembers
public class FDBarButtonItem: NSObject {
    
    /// 在navigationItem.leftBarButtonItems/navigationItem.rightBarButtonItems
    /// 的count大于1时，当前barButtonItem相对于前一个的边距.
    /// 如果只有leftBarButtonItems/rightBarButtonItems只有一个，那么设置这个属性是没有
    /// 用的，可以使用navigationBar.contentInsets来设置
    public var margin: CGFloat = 12.0 {
        didSet { delegate?.barButtonItemDidChange(self) }
    }
    
    // default is system font of size 15
    // NOTE: priority is low than titleTextAttributes
    public var font: UIFont? {
        get { return buttonView.titleLabel?.font }
        set {
            buttonView.titleLabel?.font = newValue
            delegate?.barButtonItemDidChange(self)
        }
    }
    
    // default is black
    // NOTE: priority is low than titleTextAttributes
    public var textColor: UIColor? {
        get { return buttonView.titleColor(for: .normal) }
        set {
            buttonView.setTitleColor(newValue, for: .normal)
            delegate?.barButtonItemDidChange(self)
        }
    }

    // default is nil
    public var title: String? {
        get { return buttonView.title(for: .normal) }
        set {
            buttonView.setTitle(newValue, for: .normal)
            if let title = newValue {
                for (rawValue, attributes) in titleTextAttributes {
                    buttonView.setAttributedTitle(NSAttributedString(string: title, attributes: attributes),
                                                  for: UIControl.State(rawValue: rawValue))
                }
            }
            delegate?.barButtonItemDidChange(self)
        }
    }
    
    // default is nil
    public var image: UIImage? {
        get { return buttonView.image(for: .normal) }
        set {
            buttonView.setImage(newValue, for: .normal)
            delegate?.barButtonItemDidChange(self)
        }
    }
    
    // default is NULL
    public var action: Selector?
    
    // default is nil
    public weak var target: AnyObject?
    
    // default is nil
    public var tintColor: UIColor? {
        get { return buttonView.tintColor }
        set { buttonView.tintColor = newValue }
    }
    
    // default is YES
    public var isEnabled: Bool {
        get { return buttonView.isEnabled }
        set { buttonView.isEnabled = newValue }
    }
    
    // default is UIEdgeInsetsZero
    public var imageInsets: UIEdgeInsets {
        get { return buttonView.imageEdgeInsets }
        set {
            buttonView.imageEdgeInsets = newValue
            delegate?.barButtonItemDidChange(self)
        }
    }
    
    // default is UIEdgeInsetsZero
    public var titleInsets: UIEdgeInsets {
        get { return buttonView.titleEdgeInsets }
        set {
            buttonView.titleEdgeInsets = newValue
            delegate?.barButtonItemDidChange(self)
        }
    }
    
    // default is nil
    // NOTE: If you use custom view, you should
    // control it all by your self, properties and
    // functions in this class are not support customView.
    public private(set) var customView: UIView?
    
    public init(title: String? = nil,
                image: UIImage? = nil,
                target: AnyObject? = nil,
                action: Selector? = nil) {
        super.init()
        self.title = title
        self.image = image
        self.target = target
        self.action = action
    }
    
    public init(customView: UIView) {
        super.init()
        self.customView = customView
    }
    
    // MARK: Appearance modifiers
    
    /// In general, you should specify a value for the normal state
    /// to be used by other states which don't have a custom value set.
    public func setBackgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State) {
        if state == .normal ||
            state == .disabled ||
            state == .highlighted {
            buttonView.setBackgroundImage(backgroundImage, for: state)
        } else {
            // Similar to UIKit's implementation
            buttonView.setBackgroundImage(backgroundImage, for: .highlighted)
        }
    }
    
    public func backgroundImage(for state: UIControl.State) -> UIImage? {
        if state == .normal ||
            state == .disabled ||
            state == .highlighted {
            return buttonView.backgroundImage(for: state)
        } else {
            // Similar to UIKit's implementation
            return buttonView.backgroundImage(for: .highlighted)
        }
    }
    
    /// You may specify the font, text color, and shadow properties
    /// for the title in the text attributes dictionary, using the keys
    /// found in NSAttributedString.h.
    private lazy var titleTextAttributes = [UIControl.State.RawValue : [NSAttributedString.Key : Any]]()
    
    public func setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State) {
        if state == .normal ||
            state == .disabled ||
            state == .highlighted {
            titleTextAttributes[state.rawValue] = attributes
            if let title = title {
                buttonView.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: state)
                delegate?.barButtonItemDidChange(self)
            }
        } else {
            // Similar to UIKit's implementation
            titleTextAttributes[UIControl.State.highlighted.rawValue] = attributes
            if let title = title {
                buttonView.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .highlighted)
                delegate?.barButtonItemDidChange(self)
            }
        }
    }
    
    public func titleTextAttributes(for state: UIControl.State) -> [NSAttributedString.Key : Any]? {
        if state == .normal ||
            state == .disabled ||
            state == .highlighted {
            return titleTextAttributes[state.rawValue]
        } else {
            // Similar to UIKit's implementation
            return titleTextAttributes[UIControl.State.highlighted.rawValue]
        }
    }
    
    /// Internal use only
    weak var delegate: FDBarButtonItemDelegate?
    
    lazy var buttonView: UIButton = {
        let v = UIButton()
        v.setTitleColor(.black, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 15)
        v.addTarget(self, action: #selector(_sendAction(_:)), for: .touchUpInside)
        return v
    }()
}

extension FDBarButtonItem {
    @objc func _sendAction(_ sender: UIButton) {
        if let target = target, let action = action {
            _ = target.perform(action)
        } else {
            debugPrint("WRANING: Missing `target` or `action`, please take a look.")
        }
    }
}
