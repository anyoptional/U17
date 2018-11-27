//
//  BundleLoader.swift
//  Fate
//
//  Created by Archer on 2018/11/26.
//

import Foundation

// MARK: 加载Fate.bundle里面的图片资源

class FateBundleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: FateBundleLoader.self).resourcePath ?? ""
        path.append("/Fate.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}
