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
        let vc = U17ProfileViewController()
        vc.reactor = U17ProfileViewReactor()
        return vc
    }
    
}
