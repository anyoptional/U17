//
//  U17TabBarController.swift
//  AppMain
//
//  Created by Archer on 2018/11/20.
//

import Mediator

final class U17TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        appearanceAdjustify()
    }
    
    private func appearanceAdjustify() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = false
    }
    
    private func initialize() {
        if let todayVc = Mediator.getTodayViewController(),
            let discoverVc = Mediator.getDiscoverViewController(),
            let bookshelfVc = Mediator.getBookshelfViewController(),
            let profileVc = Mediator.getProfileViewController() {
            addChildViewController(vc: todayVc, title: "今日", image: "home", selectedImage: "home_1")
            addChildViewController(vc: discoverVc, title: "发现", image: "find", selectedImage: "find_1")
            addChildViewController(vc: bookshelfVc, title: "书架", image: "favor", selectedImage: "favor_1")
            addChildViewController(vc: profileVc, title: "我的", image: "me", selectedImage: "me_1")
        }
    }
    
    private func addChildViewController(vc: UIViewController, title: String, image: String, selectedImage: String) {
        vc.tabBarItem.title = title
        vc.tabBarItem.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 11), .foregroundColor : UIColor.black], for: .normal)
        vc.tabBarItem.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 11), .foregroundColor : UIColor.red], for: .selected)
        vc.tabBarItem.image = UIImage(nameInBundle: image)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(nameInBundle: selectedImage)?.withRenderingMode(.alwaysOriginal)
        addChild(U17NavigationController(rootViewController: vc));
    }
}
