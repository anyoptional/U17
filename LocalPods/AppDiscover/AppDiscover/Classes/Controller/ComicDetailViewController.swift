//
//  ComicDetailViewController.swift
//  AppDiscover
//
//  Created by Archer on 2018/12/28.
//

import UIKit
import FOLDin
import ReactorKit

class ComicDetailViewController: UIViewController {

    /// 漫画ID
    var comicId = ""
    
    override var prefersNavigationBarStyle: UINavigationBarStyle {
        return .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildNavbar()
    }
}

extension ComicDetailViewController: View {
    func bind(reactor: ComicDetailViewReactor) {
        
    }
}

extension ComicDetailViewController {
    private func buildNavbar() {
        
    }
    
    private func buildUI() {
        view.backgroundColor = .white
    }
}
