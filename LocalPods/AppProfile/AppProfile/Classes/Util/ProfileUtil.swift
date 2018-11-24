
//
//  ProfileUtil.swift
//  AppProfile
//
//  Created by Archer on 2018/11/20.
//

import Foundation

class AppProfileBunbleLoader: NSObject {}

extension Bundle {
    static var resourcesBundle: Bundle? {
        var path = Bundle(for: AppProfileBunbleLoader.self).resourcePath ?? ""
        path.append("/AppProfile.bundle")
        return Bundle(path: path)
    }
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}
