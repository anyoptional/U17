//
//  U17SearchResultCell.swift
//  AppSearch
//
//  Created by Archer on 2018/12/28.
//

import Fate
import YYKit
import SnapKit
import RxBindable

class U17SearchResultCell: UITableViewCell {
    
    private lazy var imgView: UIImageView = {
        let v = UIImageView()
        // 画圆角什么的就不弄了偷个懒
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFill
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.textColor = U17def.black_333333
        v.font = UIFont.boldSystemFont(ofSize: 17)
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var detailLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textAlignment = .left
        v.textColor = U17def.gray_AAAAAA
        v.font = UIFont.boldSystemFont(ofSize: 11)
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var tagLabel: YYLabel = {
        let v = YYLabel()
        v.textAlignment = .left
        v.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        contentView.addSubview(v)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 115, height: 150))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(15)
            make.top.equalTo(15)
            make.right.equalTo(-15)
        }
        
        tagLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-13)
            make.left.equalTo(imgView.snp.right).offset(11)
            make.right.equalTo(titleLabel)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(tagLabel.snp.top).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension U17SearchResultCell: Bindable {
    func bind(display: U17SearchResultCellDisplay) {
        
        let presenter = display.state.presenter
        
        titleLabel.text = presenter.titleText
        
        detailLabel.text = presenter.detailText
        
        tagLabel.attributedText = presenter.tagAttributedText
        
        imgView.fate.setImage(withURL: presenter.imageURL,
                              placeholder: UIImage(nameInBundle: "classify_placeholder"))
    }
}
