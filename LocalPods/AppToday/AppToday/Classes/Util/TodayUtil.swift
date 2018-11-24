//
//  TodayUtil.swift
//  AppToday
//
//  Created by Archer on 2018/11/20.
//

import Foundation

class AppTodayBunbleLoader: NSObject {}

extension Bundle {
    static var resourcesBundle: Bundle? {
        var path = Bundle(for: AppTodayBunbleLoader.self).resourcePath ?? ""
        path.append("/AppToday.bundle")
        return Bundle(path: path)
    }
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}
