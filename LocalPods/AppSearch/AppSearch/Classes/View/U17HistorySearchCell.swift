//
//  U17HistorySearchCell.swift
//  AppSearch
//
//  Created by Archer on 2018/12/5.
//

import Fate
import SnapKit
import RxBindable

class U17HistorySearchCell: UITableViewCell {
    
    private lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = U17def.gray_EAEAEA
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.textColor = U17def.gray_8E8E8E
        v.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(v)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(45)
            make.top.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.7)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension U17HistorySearchCell: Bindable {
    func bind(display: U17HistorySearchCellDisplay) {
        
    }
}
