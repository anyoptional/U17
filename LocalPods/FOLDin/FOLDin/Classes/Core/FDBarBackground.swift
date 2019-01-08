//
//  FDBarBackground.swift
//  FOLDin
//
//  Created by Archer on 2018/12/10.
//

import UIKit

fileprivate let kFDShadowImageViewHeight: CGFloat = 0.5

/// Blur effect is not supported
class FDBarBackground: UIView {
    
    var shadowImage: UIImage? {
        didSet {
            if shadowImage != oldValue {
                shadowImageView.image = shadowImage
                shadowImageView.isHidden = shadowImage == nil
            }
        }
    }
    
    var backgroundImage: UIImage? {
        didSet {
            if backgroundImage != oldValue {
                backgroundImageView.image = backgroundImage
                backgroundImageView.isHidden = backgroundImage == nil
            }
        }
    }
    
    private lazy var shadowImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = bounds
        shadowImageView.frame = CGRect(x: 0,
                                       y: frame.height,
                                       width: frame.width,
                                       height: kFDShadowImageViewHeight)
    }
    
    init() {
        super.init(frame: .zero)
        _setupViewHierarchy()
        _configureInitailize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FDBarBackground {
    private func _setupViewHierarchy() {
        addSubview(shadowImageView)
        addSubview(backgroundImageView)
    }
    
    private func _configureInitailize() {
        backgroundColor = UIColor(rgbValue: 0xF9F9F9)
        shadowImage = UIImage.create(UIColor(rgbValue: 0xE3E3E3))
    }
}
