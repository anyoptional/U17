//
//  AppSearchTarget.swift
//  AppSearch
//
//  Created by Archer on 2018/12/4.
//

import Foundation

@objcMembers
class AppSearchTarget: NSObject {
    
    func getSearchViewController() -> UIViewController {
        let vc = U17SearchViewController()
        vc.reactor = U17SearchViewReactor()
        return vc
    }
    
}
