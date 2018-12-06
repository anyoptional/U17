//
//  U17KeywordRelativeCell.swift
//  AppSearch
//
//  Created by Archer on 2018/12/6.
//

import Fate
import SnapKit
import RxBindable

class U17KeywordRelativeCell: UITableViewCell {
    
    private lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = U17def.gray_EAEAEA
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
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

extension U17KeywordRelativeCell: Bindable {
    func bind(display: U17KeywordRelativeCellDisplay) {
        
        let presenter = display.state.presenter
        
        titleLabel.attributedText = presenter.attributedText
    }
}
