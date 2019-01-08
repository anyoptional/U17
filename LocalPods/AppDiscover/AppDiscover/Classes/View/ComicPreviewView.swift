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
        v.backgroundColor = .white
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFit
        v.layer.borderColor = UIColor.white.cgColor
        v.image = UIImage(nameInBundle: "classify_placeholder")
        addSubview(v)
        return v
    }()
    
    fileprivate lazy var tagLabel: YYLabel = {
        let v = YYLabel()
        v.textAlignment = .left
        v.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        addSubview(v)
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.layer.shadowOffset = CGSize(width: 2, height: 2)
        v.font = UIFont.boldSystemFont(ofSize: 25)
        v.layer.shadowOpacity = 0.2
        v.textAlignment = .left
        v.textColor = .white
        v.numberOfLines = 2
        addSubview(v)
        return v
    }()
    
    fileprivate lazy var detailLabel: YYLabel = {
        let v = YYLabel()
        v.layer.shadowOffset = CGSize(width: 2, height: 2)
        v.layer.shadowOpacity = 0.2
        v.textAlignment = .left
        v.numberOfLines = 3
        addSubview(v)
        return v
    }()
    
    private lazy var eggIv: UIImageView = {
        let v = UIImageView()
        v.alpha = 0
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFit
        v.image = UIImage(nameInBundle: "boutique_nomore")
        radiusView.addSubview(v)
        return v
    }()
    
    init() {
        super.init(frame: .zero)
        
        radiusView.snp.makeConstraints { (make) in
            make.top.equalTo(155)
            make.left.right.bottom.equalToSuperview()
        }
        eggIv.snp.makeConstraints { (make) in
            make.top.equalTo(70)
            make.left.right.bottom.equalToSuperview()
        }
        comicIv.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.size.equalTo(CGSize(width: 150, height: 190))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(comicIv).offset(-7)
            make.left.equalTo(comicIv.snp.right).offset(10)
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
        
        // 彩蛋嘛 当然要晚一点出来了
        DispatchQueue.main.asyncAfter(deadline: 5) {
            UIView.animate(withDuration: 0.25, animations: {
                self.eggIv.alpha = 1
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComicPreviewView: Bindable {
    func bind(display: ComicPreviewViewDisplay) {
        
        let presenter = display.state.presenter
        
        titleLabel.text = presenter.titleText
        
        detailLabel.attributedText = presenter.detailAttributedText
        
        tagLabel.attributedText = presenter.tagAttributedText
            
        comicIv.fate.setImage(withURL: presenter.imageURL, placeholder: UIImage(nameInBundle: "classify_placeholder"))
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
    
    /// 绑定display
    var display: Binder<ComicPreviewViewDisplay> {
        return Binder(base, binding: { (previewView, display) in
            previewView.display = display
        })
    }
    
    /// 其他作品
    var showsOtherWork: Observable<[ComicStaticDetailResp.DataBean.ReturnDataBean.OtherWorksBean]> {
        return Observable.create({ [weak base] (observer) in
            if let base = base {
                base.detailLabel.highlightTapAction = { (container, attrString, range, rect) in
                    let otherWorks = (base.display?.state.rawValue.otherWorks).filterNil([])
                    observer.onNext(otherWorks)
                }
            } else {
                observer.onCompleted()
            }
            return Disposables.create()
        }).takeUntil(deallocated)
    }
}
