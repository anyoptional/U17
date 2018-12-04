//
//  U17TextField.swift
//  Fate
//
//  Created by Archer on 2018/12/4.
//

import UIKit

public struct U17RectInset {
    // flag to ensure inset top is equal to inset bottom
    public static let npos: CGFloat = -1
    public static let identity: U17RectInset = U17RectInsetMake(0, 0, 0)
    
    /// x is scaled
    /// for leftView, x means insetLeft in superView
    /// for rightView, x means insetRight in superView
    public let insetX: CGFloat
    public let insetY: CGFloat
    public let fixedWidth: CGFloat
    public let fixedHeight: CGFloat
}

public func U17RectInsetMake(_ insetX: CGFloat, _ insetY: CGFloat, _ fixedWidth: CGFloat, _ fixedHeight: CGFloat = U17RectInset.npos) -> U17RectInset {
    return U17RectInset(insetX: insetX, insetY: insetY, fixedWidth: fixedWidth, fixedHeight: fixedHeight)
}

public struct U17PositionInset {
    public static let identity = U17PositionInsetMake(0, 0)
    
    public let insetLeft: CGFloat
    public let insetRight: CGFloat
}

public func U17PositionInsetMake(_ insetLeft: CGFloat, _ insetRight: CGFloat) -> U17PositionInset {
    return U17PositionInset(insetLeft: insetLeft, insetRight: insetRight)
}

public enum U17TextFiledStyle {
    case custom // unmodified pure textfiled
    case image // leftView is UIImageView, no rightView
    case ltext // leftView is UILabel, no rightView
    case rtext // rightView is UILabel, no leftView
}

open class U17TextField: UITextField {
    
    open var cursorColor: UIColor = .white {
        didSet {
            tintColor = cursorColor
        }
    }
    
    open var backgroundImage: UIImage? {
        didSet {
            background = backgroundImage
        }
    }
    
    open var leftViewInset: U17RectInset = .identity {
        didSet {
            assert(leftView != nil, "should exists")
            setNeedsLayout()
        }
    }
    
    open var rightViewInset: U17RectInset = .identity {
        didSet {
            assert(rightView != nil, "should exists")
            setNeedsLayout()
        }
    }
    
    open var isSepatatorEnabled: Bool = false {
        didSet {
            if isSepatatorEnabled {
                if !subviews.contains(where: { $0.tag == 998 }) {
                    let separatorView = UIView()
                    separatorView.tag = 998
                    separatorView.backgroundColor = separatorColor
                    addSubview(separatorView)
                }
            } else {
                if let separatorView = viewWithTag(998) {
                    separatorView.removeFromSuperview()
                }
            }
        }
    }
    
    open var separatorHeight: CGFloat = 0.7 {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var separatorColor: UIColor = .white {
        didSet {
            assert(isSepatatorEnabled, "should enabled first")
            viewWithTag(998)!.backgroundColor = separatorColor
        }
    }
    
    open var separatorInset: U17PositionInset = .identity {
        didSet {
            assert(isSepatatorEnabled, "should enabled first")
            setNeedsLayout()
        }
    }
    
    open var textAreaInset: U17PositionInset = .identity {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var extendedImage: UIImage? {
        didSet {
            assert(style == .image, "should at this style")
            (leftView as! UIImageView).image = extendedImage
        }
    }
    
    open var extendedText: String? {
        didSet {
            assert(style == .rtext || style == .ltext, "should at this style")
            if style == .ltext {
                (leftView as! UILabel).text = extendedText
            } else {
                (rightView as! UILabel).text = extendedText
            }
        }
    }
    
    open var extendedTextColor: UIColor = .white {
        didSet {
            assert(style == .rtext || style == .ltext, "should at this style")
            if style == .ltext {
                (leftView as! UILabel).textColor = extendedTextColor
            } else {
                (rightView as! UILabel).textColor = extendedTextColor
            }
        }
    }
    
    open var extendedTextFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            assert(style == .rtext || style == .ltext, "should at this style")
            if style == .ltext {
                (leftView as! UILabel).font = extendedTextFont
            } else {
                (rightView as! UILabel).font = extendedTextFont
            }        }
    }
    
    open var placeholderText: String = "" {
        didSet {
            let attrText = NSAttributedString(string: placeholderText, attributes: [.foregroundColor : placeholderColor, .font : placeholderFont])
            attributedPlaceholder = attrText;
        }
    }
    
    open var placeholderFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            let attrText = NSAttributedString(string: placeholderText, attributes: [.foregroundColor : placeholderColor, .font : placeholderFont])
            attributedPlaceholder = attrText;
        }
    }
    
    open var placeholderColor: UIColor = .white {
        didSet {
            let attrText = NSAttributedString(string: placeholderText, attributes: [.foregroundColor : placeholderColor, .font : placeholderFont])
            attributedPlaceholder = attrText;
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if isSepatatorEnabled {
            let separatorView = viewWithTag(998)!
            let x = separatorInset.insetLeft
            let y = bounds.height - separatorHeight
            let width = bounds.width - x - separatorInset.insetRight
            let height = separatorHeight
            separatorView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        if leftView != nil {
            if leftViewInset.fixedHeight == U17RectInset.npos {
                return CGRect(x: leftViewInset.insetX,
                              y: leftViewInset.insetY,
                              width: leftViewInset.fixedWidth,
                              height: bounds.height - 2 * leftViewInset.insetY)
            } else {
                return CGRect(x: leftViewInset.insetX,
                              y: leftViewInset.insetY,
                              width: leftViewInset.fixedWidth,
                              height: leftViewInset.fixedWidth)
            }
        }
        return super.leftViewRect(forBounds: bounds)
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        if rightView != nil {
            if rightViewInset.fixedHeight == U17RectInset.npos {
                let insetRight = rightViewInset.insetX
                let insetTop = rightViewInset.insetY
                let width = rightViewInset.fixedWidth
                return CGRect(x: bounds.width - insetRight - width,
                              y: insetTop,
                              width: width,
                              height: bounds.height - 2 * insetTop)
            } else {
                let insetRight = rightViewInset.insetX
                let insetTop = rightViewInset.insetY
                let width = rightViewInset.fixedWidth
                let height = rightViewInset.fixedHeight
                return CGRect(x: bounds.width - insetRight - width,
                              y: insetTop,
                              width: width,
                              height: height)
            }
        }
        return super.rightViewRect(forBounds: bounds)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetLeft = leftViewRect(forBounds: bounds).maxX + textAreaInset.insetLeft
        let insetRight = rightViewRect(forBounds: bounds).minX - textAreaInset.insetRight
        return CGRect(x: insetLeft, y: bounds.minY, width: insetRight - insetLeft, height: bounds.height)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return editingRect(forBounds: bounds)
    }
    
    private lazy var imageView: UIImageView = {
        let v = UIImageView();
        v.contentMode = .scaleAspectFit
        addSubview(v)
        return v;
    }()
    private lazy var textLabel: UILabel = {
        let label = UILabel();
        label.text = extendedText
        label.textAlignment = .right
        label.font = extendedTextFont
        label.textColor = extendedTextColor
        addSubview(label);
        return label;
    }()
    private let style: U17TextFiledStyle
    
    public init(_ style: U17TextFiledStyle = .custom) {
        self.style = style
        super.init(frame: .zero)
        self.tintColor = cursorColor
        switch style {
        case .custom: break
        case .image:
            leftView = imageView
            leftViewMode = .always
        case .ltext:
            leftView = textLabel
            leftViewMode = .always
        case .rtext:
            rightView = textLabel
            rightViewMode = .always
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
