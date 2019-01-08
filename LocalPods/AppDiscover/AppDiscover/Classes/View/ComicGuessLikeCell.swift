//
//  ComicGuessLikeCell.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/7.
//

import Fate
import UIKit
import RxBindable

class ComicGuessLikeComponentView: UIView {
    
    private lazy var imgView: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.layer.cornerRadius = 10
        v.contentMode = .scaleAspectFill
        addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.textColor = U17def.black_333333
        v.font = UIFont.systemFont(ofSize: 14)
        addSubview(v)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        imgView.snp.makeConstraints { (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(imgView.snp.width).multipliedBy(1.4)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(10)
            make.left.equalTo(2)
            make.right.equalTo(-2)
            make.bottom.equalTo(-15)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComicGuessLikeComponentView: Bindable {
    func bind(display: ComicGuessLikeComponentViewDisplay) {
        
        let presenter = display.state.presenter
        
        titleLabel.text = presenter.titleText
        
        imgView.fate.setImage(withURL: presenter.imgURL,
                              placeholder: UIImage(nameInBundle: "classify_placeholder"))
    }
}

class ComicGuessLikeCell: UITableViewCell {
    
    private lazy var leftView = ComicGuessLikeComponentView()
    private lazy var midView = ComicGuessLikeComponentView()
    private lazy var rightView = ComicGuessLikeComponentView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let views = [leftView, midView, rightView]
        views.forEach { self.contentView.addSubview($0) }
        views.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 12,
                                       leadSpacing: 13, tailSpacing: 13)
        views.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComicGuessLikeCell: Bindable {
    func bind(display: ComicGuessLikeCellDisplay) {
        
        let componentViewDisplays = display.state.presenter.componentViewDisplays
        
        if componentViewDisplays.count == 1 {
            midView.display = componentViewDisplays[0]
        } else if componentViewDisplays.count == 2 {
            leftView.display = componentViewDisplays.first
            rightView.display = componentViewDisplays.last
        } else if componentViewDisplays.count == 3 {
            leftView.display = componentViewDisplays[0]
            midView.display = componentViewDisplays[1]
            rightView.display = componentViewDisplays[2]
        } else {
            debugPrint("WARNING: Returned guess like comics is not much enough.")
        }
    }
}
