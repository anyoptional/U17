//
//  UIButton+WebCache.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import YYKit

public extension Fate where Base: UIButton {
    public func setImage(withURL imageURL: URL?, placeholder: UIImage? = nil) {
        base.setImageWith(imageURL, for: .normal, placeholder: placeholder)
    }
    
    public func setBackgroundImage(withURL imageURL: URL?, placeholder: UIImage? = nil) {
        base.setBackgroundImageWith(imageURL, for: .normal, placeholder: placeholder)
    }
}
