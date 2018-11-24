//
//  AppProfileTarget.swift
//  AppBookshelf
//
//  Created by Archer on 2018/11/23.
//

import Foundation

@objcMembers
class AppProfileTarget: NSObject {
    
    func getProfileViewController() -> UIViewController {
        let vc = ProfileViewController()
        vc.reactor = ProfileViewReactor()
        return vc
    }
    
}
