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
    
    func getComicDetailViewController(_ parameters: [String : Any]) -> UIViewController {
        guard let comicId = parameters["comicId"] as? String else {
            fatalError("Could not fetch comic id.")
        }
        let vc = ComicDetailViewController()
        vc.comicId = comicId
        vc.reactor = ComicDetailViewReactor()
        return vc
    }
}
