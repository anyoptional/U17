//
//  ComicGuessLikeCell.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/7.
//

import UIKit
import RxBindable

class ComicGuessLikeCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComicGuessLikeCell: Bindable {
    func bind(display: ComicGuessLikeCellDisplay) {
        
        let presenter = display.state.presenter
        
        textLabel?.text = display.state.rawValue
    }
}
