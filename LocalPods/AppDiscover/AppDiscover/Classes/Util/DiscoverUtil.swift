//
//  DiscoverUtil.swift
//  AppDiscover
//
//  Created by Archer on 2018/11/20.
//

import Foundation

class AppDiscoverBundleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: AppDiscoverBundleLoader.self).resourcePath ?? ""
        path.append("/AppDiscover.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}
