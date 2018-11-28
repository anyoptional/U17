
//
//  ProfileUtil.swift
//  AppProfile
//
//  Created by Archer on 2018/11/20.
//

import Foundation

class AppProfileBundleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: AppProfileBundleLoader.self).resourcePath ?? ""
        path.append("/AppProfile.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}
