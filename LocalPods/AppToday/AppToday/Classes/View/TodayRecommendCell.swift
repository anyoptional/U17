//
//  TodayRecommendCell.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import Fate
import YYKit
import Bindable

class TodayRecommendCell: UITableViewCell {
    
    private lazy var imgView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.textColor = U17def.black_333333
        v.font = UIFont.boldSystemFont(ofSize: 15)
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var tagLabel: YYLabel = {
        let v = YYLabel()
        v.textAlignment = .left
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var authorLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .right
        v.textColor = U17def.gray_9B9B9B
        v.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var updateLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.textColor = U17def.gray_9B9B9B
        v.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(v)
        return v
    }()
    
    private lazy var chapterLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .right
        v.textColor = U17def.gray_9B9B9B
        v.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(v)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        imgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(250)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.top.equalTo(imgView.snp.bottom).offset(15)
        }
        authorLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-18)
            make.centerY.equalTo(titleLabel)
        }
        updateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(-16)
        }
        chapterLabel.snp.makeConstraints { (make) in
            make.right.equalTo(authorLabel)
            make.centerY.equalTo(updateLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TodayRecommendCell: Bindable {
    func bind(display: TodayRecommendCellDisplay) {
        
        let presenter = display.state.presenter
        
        titleLabel.text = presenter.titleText
        
        authorLabel.text = presenter.authorText
        
        updateLabel.text = presenter.updateText
        
        chapterLabel.text = presenter.chapterText
        
        imgView.fate.setImage(withURL: presenter.imgURL,
                              placeholder: UIImage(nameInBundle: "today_list_placeholder"))
    }
}
