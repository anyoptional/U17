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
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().shadowImage = UIGraphicsImageCreate(UIColor(red: 230.0 / 255.0,
                                                                          green: 230.0 / 255.0,
                                                                          blue: 230.0 / 255.0, alpha: 1))
        UITabBar.appearance().backgroundImage = UIGraphicsImageCreate(.white)
    }
    
    private func initialize() {
        if let todayVc = Mediator.getTodayViewController(),
            let discoverVc = Mediator.getDiscoverViewController(),
            let bookshelfVc = Mediator.getBookshelfViewController(),
            let profileVc = Mediator.getProfileViewController() {
            addChildViewController(vc: todayVc, image: "tab_today", selectedImage: "tab_today_selected")
            addChildViewController(vc: discoverVc, image: "tab_find", selectedImage: "tab_find_selected")
            addChildViewController(vc: bookshelfVc, image: "tab_book", selectedImage: "tab_book_selected")
            addChildViewController(vc: profileVc, image: "tab_mine", selectedImage: "tab_mine_selected")
        }
    }
    
    private func addChildViewController(vc: UIViewController, image: String, selectedImage: String) {
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -5, right: 0)
        vc.tabBarItem.image = UIImage(nameInBundle: image)?
            .withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(nameInBundle: selectedImage)?
            .withRenderingMode(.alwaysOriginal)
        addChild(U17NavigationController(rootViewController: vc))
    }
}

fileprivate func UIGraphicsImageCreate(_ color: UIColor, _ size: CGSize = CGSize(width: 1, height: 0.5)) -> UIImage? {
    if size.width <= 0 || size.height <= 0 { return nil }
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    defer { UIGraphicsEndImageContext() }
    let ctx = UIGraphicsGetCurrentContext()
    ctx?.setFillColor(color.cgColor)
    ctx?.fill(rect)
    return UIGraphicsGetImageFromCurrentImageContext()
}

#if false
extension UIImage {
    fileprivate func resize(to size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
#endif
