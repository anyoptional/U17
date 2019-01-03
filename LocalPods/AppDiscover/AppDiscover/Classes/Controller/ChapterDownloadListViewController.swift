//
//  ChapterDownloadListViewController.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/2.
//

import UIKit
import FOLDin
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

class ChapterDownloadListViewController: UIViewController {

    override var prefersNavigationBarStyle: UINavigationBarStyle {
        return .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildNavbar()
    }

    deinit { NSLog("\(className()) is deallocating...") }
}

extension ChapterDownloadListViewController: View {
    func bind(reactor: ChapterDownloadListViewReactor) {
        
    }
}

extension ChapterDownloadListViewController {

}

extension ChapterDownloadListViewController {
    private func buildNavbar() {
        fd.navigationItem.title = "选择章节"
    }
    
    private func buildUI() {
        view.backgroundColor = .white
    }
}
