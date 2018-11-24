//
//  TodayRecommandCell.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import UIKit
import Bindable

class TodayRecommandCell: UITableViewCell {
    
    private lazy var imgView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFill
        contentView.addSubview(v)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(9)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-9)
            make.height.equalTo(500)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TodayRecommandCell: Bindable {
    func bind(display: TodayRecommandCellDisplay) {
        
        let presenter = display.state.presenter
        
        imgView.fate.setImage(withURL: presenter.imgURL)
    }
}
