//
//  UIImageView+WebCache.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import YYKit

public extension Fate where Base: UIImageView {
    public func setImage(withURL imageURL: URL?, placeholder: UIImage? = nil,
                  options: YYWebImageOptions = [.setImageWithFadeAnimation, .progressive, .progressiveBlur]) {
        base.setImageWith(imageURL, placeholder: placeholder, options: options)
    }
}
