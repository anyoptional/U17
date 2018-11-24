//
//  AppBookshelfTarget.swift
//  AppBookshelf
//
//  Created by Archer on 2018/11/23.
//

import Foundation

@objcMembers
class AppBookshelfTarget: NSObject {
    
    func getBookshelfViewController() -> UIViewController {
        let vc = BookshelfViewController()
        vc.reactor = BookshelfViewReactor()
        return vc
    }
    
}
