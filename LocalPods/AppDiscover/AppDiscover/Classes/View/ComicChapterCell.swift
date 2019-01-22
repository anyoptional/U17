//
//  ComicChapterCell.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/7.
//

import Fate
import UIKit
import SnapKit
import RxBindable

class ComicChapterCell: UITableViewCell {

    private lazy var imgView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.layer.cornerRadius = 10
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.textColor = U17def.black_333333
        v.font = UIFont.boldSystemFont(ofSize: 13)
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var detailLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.textColor = U17def.gray_999999
        v.font = UIFont.systemFont(ofSize: 11)
        contentView.addSubview(v)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(13)
            make.size.equalTo(CGSize(width: 120, height: 70))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(11)
            make.bottom.equalTo(imgView.snp.centerY).offset(-4)
            make.right.equalTo(-13)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.centerY).offset(4)
            make.left.right.equalTo(titleLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComicChapterCell: Bindable {
    func bind(display: ComicChapterCellDisplay) {
        
        let presenter = display.state.presenter
        
        titleLabel.text = presenter.titleText
        
        detailLabel.text = presenter.detailText
        
        imgView.fate.setImage(withURL: presenter.imgURL, placeholder: UIImage(nameInBundle: "classify_placeholder"))
    }
}
