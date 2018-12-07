//
//  SearchUtil.swift
//  AppSearch
//
//  Created by Archer on 2018/12/4.
//

import Foundation

class AppSearchBundleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: AppSearchBundleLoader.self).resourcePath ?? ""
        path.append("/AppSearch.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}


struct SearchUtil {
    
}
