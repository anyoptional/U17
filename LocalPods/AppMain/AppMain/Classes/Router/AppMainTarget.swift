//
//  AppMainTarget.swift
//  AppMain
//
//  Created by Archer on 2018/11/21.
//

import Foundation

class AppMainBunbleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: AppMainBunbleLoader.self).resourcePath ?? ""
        path.append("/AppMain.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}

public struct AppMainTarget {
    
    /// Application's root view controller
    public static func rootViewController() -> UIViewController {
        return U17TabBarController()
    }
}
