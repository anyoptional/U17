//
//  BookshelfUtil.swift
//  AppBookshelf
//
//  Created by Archer on 2018/11/20.
//

import Foundation

class AppBookshelfBundleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: AppBookshelfBundleLoader.self).resourcePath ?? ""
        path.append("/AppBookshelf.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}
