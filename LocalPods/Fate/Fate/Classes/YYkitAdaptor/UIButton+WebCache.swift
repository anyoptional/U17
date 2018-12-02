//
//  UIButton+WebCache.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import YYKit

public extension Fate where Base: UIButton {
    public func setImage(withURL imageURL: URL?, placeholder: UIImage? = nil,
                         options: YYWebImageOptions = [.setImageWithFadeAnimation, .progressive, .progressiveBlur]) {
        base.setImageWith(imageURL, for: .normal, placeholder: placeholder, options: options)
    }
    
    public func setBackgroundImage(withURL imageURL: URL?, placeholder: UIImage? = nil,
                                   options: YYWebImageOptions = [.setImageWithFadeAnimation, .progressive, .progressiveBlur]) {
        base.setBackgroundImageWith(imageURL, for: .normal, placeholder: placeholder, options: options)
    }
}
