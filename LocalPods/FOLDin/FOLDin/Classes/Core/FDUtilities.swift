//
//  FDUtilities.swift
//  FOLDin
//
//  Created by Archer on 2018/12/14.
//  Copyright © 2018年 Archer. All rights reserved.
//

import Foundation

class FOLDinBundleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: FOLDinBundleLoader.self).resourcePath ?? ""
        path.append("/FOLDin.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}
