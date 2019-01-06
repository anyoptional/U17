//
//  ComicImageView.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/6.
//

import UIKit
import RxSwift
import RxCocoa
import RxBindable
import SDWebImage

class ComicImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        contentMode = .scaleAspectFill
        image = UIImage(nameInBundle: "detailDefault")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComicImageView: Bindable {
    func bind(display: ComicImageViewDisplay) {
        
        let presenter = display.state.presenter
        
        sd_setImage(with: presenter.backgroundImageURL,
                    placeholderImage: UIImage(nameInBundle: "detailDefault"),
                    options: [.avoidAutoSetImage]) { [weak self] (image, error, cacheType, url) in
                        if let image = image, let url = url {
                            // 下载的 更新缓存
                            if cacheType == .none {
                                let image = image.byBlur(withTint: presenter.backgroundImageColor)
                                self?.image = image
                                SDImageCache.shared().store(image, forKey: url.absoluteString, completion: nil)
                            } else {
                                // 非下载直接设置
                                self?.image = image
                            }
                        }
        }
    }
}

extension Reactive where Base: ComicImageView {
    
    /// 绑定display
    var display: Binder<ComicImageViewDisplay> {
        return Binder(base, binding: { (imageView, display) in
            imageView.display = display
        })
    }
}
