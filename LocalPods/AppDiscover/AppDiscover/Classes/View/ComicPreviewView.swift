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
import SDWebImage // 封装一下会好点儿
import RxBindable

class ComicPreviewView: UIView {

    private lazy var coverIv: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
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
    }() // 234 247 250 | 90 197 214
    
    private lazy var comicIv: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10
        v.layer.borderWidth = 3.5
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
    
    private lazy var titleLabel: YYLabel = {
        let v = YYLabel()
        v.text = "光之契约"
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
        v.text = "美盛游戏\n\n热度值 256.6万"
        v.layer.shadowOffset = CGSize(width: 2, height: 2)
        v.layer.shadowOpacity = 0.2
        v.textAlignment = .left
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
            make.bottom.equalTo(comicIv).offset(-10)
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
        
        coverIv.sd_setImage(with: presenter.backgroundImageURL,
                            placeholderImage: UIImage(nameInBundle: "detailDefault"),
                            options: [.avoidAutoSetImage]) { [weak self] (image, error, cacheType, url) in
                                if let image = image, let url = url {
                                    // 下载的 更新缓存
                                    if cacheType == .none {
                                        let image = image.byBlur(withTint: presenter.backgroundImageColor)
                                        self?.coverIv.image = image
                                        SDImageCache.shared().store(image, forKey: url.absoluteString, completion: nil)
                                    } else {
                                        // 非下载直接设置
                                        self?.coverIv.image = image
                                    }
                                }
        }
        
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
