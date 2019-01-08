//
//  FDNavigationBar.swift
//  FOLDin
//
//  Created by Archer on 2018/12/10.
//

import UIKit

@objcMembers
public class FDNavigationBar: UIView {
    
    @available(*, deprecated: 1.0, message: "Use `barTintColor` or `backgroundImage` instead.")
    public override var backgroundColor: UIColor? {
        get { return barTintColor }
        set { barTintColor = newValue }
    }

    /// default is 0xF9F9F9
    public dynamic var barTintColor: UIColor? {
        get { return backView.backgroundColor }
        set {
            if barTintColor != newValue {
                backView.backgroundColor = newValue
            }
        }
    }
    
    /* In general, you should specify a value for the normal state to be used by other states which don't have a custom value set.
     
     Similarly, when a property is dependent on the bar metrics (on the iPhone in landscape orientation, bars have a different height from standard), be sure to specify a value for UIBarMetricsDefault.
     */
    
    public dynamic var backgroundImage: UIImage? {
        didSet {
            if backgroundImage != oldValue {
                backView.backgroundImage = backgroundImage
            }
        }
    }
    
    /* Default is not nil. When non-nil, a custom shadow image to show instead of the default shadow image. For a custom shadow to be shown, a custom background image must also be set with -setBackgroundImage:forBarMetrics: (if the default background image is used, the default shadow image will be used).
     */
    public dynamic var shadowImage: UIImage? {
        didSet {
            if shadowImage != oldValue {
                backView.shadowImage = shadowImage
            }
        }
    }
    
    // Content margin of content view
    public dynamic var contentMargin: FDMargin {
        didSet {
            if contentMargin != oldValue {
                contentView.contentMargin = contentMargin
            }
        }
    }
    
    /* You may specify the font, text color, and shadow properties for the title in the text attributes dictionary, using the keys found in NSAttributedString.h.
     */
    public dynamic var titleTextAttributes: [NSAttributedString.Key : Any]? {
        didSet { contentView.titleTextAttributesDidChange(titleTextAttributes) }
    }
    
    // MARK: Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        _layoutSubviews()
    }
    
    // MARK: View hierarchy
    private lazy var backView = FDBarBackground()
    private lazy var contentView = FDNavigationBarContentView()
    
    // MARK: Initializers
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        contentMargin = FDMargin(left: 12, right: 12)
        super.init(frame: frame)
        _setupViewHierarchy()
        _configureInitailize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FDNavigationBar: FDNavigationItemDelegate {
    func navigationItemDidChange(_ item: FDNavigationItem) {
        contentView.navigationItemDidChange(item)
    }
}

extension FDNavigationBar: FDMarginDelegate {
    func marginDidChange(_ margin: FDMargin) {
        contentMargin = margin
        contentMargin.delegate = self
    }
}

extension FDNavigationBar {
    private func _setupViewHierarchy() {
        addSubview(backView)
        addSubview(contentView)
    }
    
    private func _configureInitailize() {
        contentMargin.delegate = self
        contentView.contentMargin = contentMargin
        barTintColor = UIColor(rgbValue: 0xF9F9F9)
        backView.backgroundColor = barTintColor
        shadowImage = UIImage.create(UIColor(rgbValue: 0xE3E3E3))
        backView.shadowImage = shadowImage
    }
    
    private func _layoutSubviews() {
        contentView.frame = bounds
        backView.frame = CGRect(x: 0,
                                y: -frame.minY,
                                width: frame.width,
                                height: frame.height + frame.minY)
    }
}
