//
//  ComicCategoryViewController.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/3.
//

import Fate
import UIKit
import FOLDin
import RxSwift
import RxCocoa
import Mediator
import ReactorKit
import RxDataSources

class ComicCategoryViewController: UIViewController {

    /// 当前分类
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildNavbar()
    }
}

extension ComicCategoryViewController: View {
    func bind(reactor: ComicCategoryViewReactor) {
        
    }
}

extension ComicCategoryViewController {
    /// MARK: 跳转搜索
    @objc private func jumpToComicSearch() {
        if let vc = Mediator.getSearchViewController() {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ComicCategoryViewController {
    private func buildNavbar() {
        fd.navigationItem.title = "分类"
        fd.navigationItem.rightBarButtonItem = FDBarButtonItem(image: UIImage(nameInBundle: "home_page_search"),
                                                               target: self, action: #selector(jumpToComicSearch))
    }
    
    private func buildUI() {
        view.backgroundColor = .white
    }
}
