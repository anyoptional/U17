//
//  U17DiscoverViewController.swift
//  AppBookshelf
//
//  Created by Archer on 2018/11/20.
//

import Fate
import FOLDin
import Mediator
import ReactorKit

class U17DiscoverViewController: UIViewController {

    override var prefersNavigationBarStyle: UINavigationBarStyle {
        return .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hexString: "#30DC91")
    }
}

extension U17DiscoverViewController: View {
    func bind(reactor: U17DiscoverViewReactor) {
        
    }
}
