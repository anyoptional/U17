//
//  AppDiscoverTarget.swift
//  AppBookshelf
//
//  Created by Archer on 2018/11/23.
//

import Foundation

@objcMembers
class AppDiscoverTarget: NSObject {
    
    func getDiscoverViewController() -> UIViewController {
        let vc = DiscoverViewController()
        vc.reactor = DiscoverViewReactor()
        return vc
    }
    
}
