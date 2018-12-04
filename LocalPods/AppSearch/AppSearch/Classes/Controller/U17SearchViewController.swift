//
//  U17SearchViewController.swift
//  AppSearch
//
//  Created by Archer on 2018/12/4.
//

import Fate
import RxSwift
import RxCocoa
import RxSwiftExt
import ReactorKit

class U17SearchViewController: UIViewController {
    
    private lazy var searchBar: U17SearchBar = {
        let width = view.width - 70
        let height = 25.toCGFloat()
        return U17SearchBar(size: CGSize(width: width, height: height))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
}

extension U17SearchViewController {
    // MARK: 取消搜索
    @objc private func popViewController() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension U17SearchViewController: View {
    func bind(reactor: U17SearchViewReactor) {
        

        
        
    }
}

extension U17SearchViewController {
    func buildNavbar() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain,
                                                            target: self, action: #selector(popViewController))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 15),
                                                                   .foregroundColor : U17def.gray_C5C5C5], for: .normal)
        
    }
    
    func buildUI() {
        view.backgroundColor = .white
    }
}
