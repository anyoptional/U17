//
//  ProfileViewController.swift
//  AppProfile
//
//  Created by Archer on 2018/11/20.
//

import Fate
import ReactorKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(rgbValue: 0x30DC91)
    }
    
}

extension ProfileViewController: View {
    func bind(reactor: ProfileViewReactor) {
        
    }
}
