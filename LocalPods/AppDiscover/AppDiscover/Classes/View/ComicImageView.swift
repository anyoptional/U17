//
//  ComicImageView.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/6.
//

import UIKit
import YYKit
import RxSwift
import RxCocoa
import RxBindable
import SDWebImage

class ComicImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        contentMode = .scaleAspectFill
        image = UIImage(color: UIColor(rgb: 0x5F5F5F))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComicImageView {
    private func addFadeAnimation() {
        if !isHighlighted { layer.removeAnimation(forKey: "_KFadeAnimationKey") }
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        layer.add(transition, forKey: "_KFadeAnimationKey")
    }
}

extension ComicImageView: Bindable {
    func bind(display: ComicImageViewDisplay) {
        
        let presenter = display.state.presenter
        
        // 更换一下缓存的key 避免影响到cover
        if let imageURL = presenter.backgroundImageURL {
            let key = "_comic_bg_" + imageURL.absoluteString
            // hit cache
            if let image = SDImageCache.shared().imageFromCache(forKey: key) {
                addFadeAnimation()
                self.image = image
            } else {
                sd_setImage(with: imageURL,
                            placeholderImage: UIImage(nameInBundle: "detailDefault"),
                            options: [.avoidAutoSetImage])
                { [weak self] (image, error, cacheType, url) in
                    if let image = image {
                        // 下载的 更新缓存
                        if cacheType == .none {
                            var finalImage: UIImage?
                            if let color = presenter.backgroundImageColor {
                                finalImage = image.fate.setColorFilter(color)
                            } else {
                                finalImage = image.byBlurSoft()
                            }
                            self?.addFadeAnimation()
                            self?.image = finalImage
                            SDImageCache.shared().store(finalImage, forKey: key, completion: nil)
                        } else {
                            // 非下载直接设置
                            self?.image = image
                            self?.addFadeAnimation()
                        }
                    }
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
