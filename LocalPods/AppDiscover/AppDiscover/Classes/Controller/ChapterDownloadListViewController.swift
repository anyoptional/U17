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
    @objc private func popViewControllerAnimated() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChapterDownloadListViewController {
    private func buildNavbar() {
        fd.navigationItem.title = "选择章节"
        fd.navigationBar.contentMargin.left = 9
        let backBarButton = UIButton()
        backBarButton.size = CGSize(width: 28, height: 28)
        backBarButton.setImage(UIImage(nameInBundle: "backGreen"), for: .normal)
        backBarButton.addTarget(self, action: #selector(popViewControllerAnimated), for: .touchUpInside)
        fd.navigationItem.leftBarButtonItem = FDBarButtonItem(customView: backBarButton)
    }
    
    private func buildUI() {
        view.backgroundColor = .white
    }
}
