//
//  DiscoverViewController.swift
//  AppBookshelf
//
//  Created by Archer on 2018/11/20.
//

import Fate
import FOLDin
import Mediator
import ReactorKit

class DiscoverViewController: UIViewController {

    override var prefersNavigationBarStyle: UINavigationBarStyle {
        return .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hexString: "#30DC91")
        
//        fd.navigationItem.hidesBackButton = true
        fd.navigationItem.rightBarButtonItem = FDBarButtonItem(title: "测试")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }
}

extension DiscoverViewController: View {
    func bind(reactor: DiscoverViewReactor) {
        
    }
}
