//
//  AppBookshelfTarget.swift
//  AppBookshelf
//
//  Created by Archer on 2018/11/23.
//

import Foundation

@objcMembers
class AppTodayTarget: NSObject {
    
    func getTodayViewController() -> UIViewController {
        let vc = TodayViewController()
        return vc
    }
    
}
