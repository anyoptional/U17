//
//  TodayUtil.swift
//  AppToday
//
//  Created by Archer on 2018/11/20.
//

import Foundation

class AppTodayBundleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: AppTodayBundleLoader.self).resourcePath ?? ""
        path.append("/AppToday.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}
