//
//  ComicPreviewView.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/2.
//

import Fate
import UIKit
import YYKit
import RxSwift
import RxCocoa
import RxBindable

class ComicPreviewView: UIView {

    private lazy var coverIv: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(nameInBundle: "detailDefault")
        addSubview(v)
        return v
    }()

    private lazy var radiusView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 15
        v.layer.masksToBounds = true
        addSubview(v)
        return v
    }()
    
    private lazy var comicIv: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.borderWidth = 3.5
        v.layer.masksToBounds = true
        v.layer.borderColor = UIColor.white.cgColor
        v.image = UIImage(nameInBundle: "classify_placeholder")
        addSubview(v)
        return v
    }()
    
    fileprivate lazy var tagLabel: YYLabel = {
        let v = YYLabel()
        v.textAlignment = .left
        v.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: YYLabel = {
        let v = YYLabel()
        v.text = "光之契约"
        v.layer.shadowOffset = CGSize(width: 2, height: 2)
        v.font = UIFont.boldSystemFont(ofSize: 25)
        v.layer.shadowOpacity = 0.15
        v.textAlignment = .left
        v.textColor = .white
        v.numberOfLines = 2
        addSubview(v)
        return v
    }()
    
    private lazy var detailLabel: YYLabel = {
        let v = YYLabel()
        v.text = "美盛游戏\n\n热度值 256.6万"
        v.layer.shadowOffset = CGSize(width: 2, height: 2)
        v.font = UIFont.systemFont(ofSize: 14)
        v.layer.shadowOpacity = 0.15
        v.textAlignment = .left
        v.textColor = .white
        v.numberOfLines = 3
        addSubview(v)
        return v
    }()
    
    init() {
        super.init(frame: .zero)
        
        coverIv.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-45) // 算上15个点的圆角
        }
        radiusView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        comicIv.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-10)
            make.size.equalTo(CGSize(width: 150, height: 190))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(comicIv)
            make.left.equalTo(comicIv.snp.right).offset(20)
            make.right.equalTo(-20)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(comicIv)
            make.left.equalTo(comicIv.snp.right).offset(10)
            make.right.equalTo(-20)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(radiusView.snp.top).offset(-12)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: ComicPreviewView {
    
    /// 点击标签上的关键字
    var showsCategory: Observable<String> {
        return Observable.create({ [weak base] (observer) in
            if let base = base {
                base.tagLabel.highlightTapAction = { (container, attrString, range, rect) in
                    let category = attrString.attributedSubstring(from: range).string
                    observer.onNext(category.trimmed)
                }
            } else {
                observer.onCompleted()
            }
            return Disposables.create()
        }).takeUntil(deallocated)
    }
}
