//
//  UIImageView+WebCache.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import SDWebImage

public extension Fate where Base: UIImageView {
    public func setImage(withURL imageURL: URL?,
                         placeholder: UIImage? = nil,
                         shouldDecompressImages: Bool = true,
                         shouldSetImageWithFadeAnimation: Bool = true) {
        SDImageCache.shared().config.shouldDecompressImages = shouldDecompressImages
        SDWebImageDownloader.shared().shouldDecompressImages = shouldDecompressImages
        let options: SDWebImageOptions = shouldSetImageWithFadeAnimation ? [.avoidAutoSetImage] : [.progressiveDownload]
        base.sd_setImage(with: imageURL,
                    placeholderImage: placeholder,
                    options: options,
                    completed: { [weak base] (image, error, _, key) in
                        guard let base = base else { return }
                        if let image = image {
                            if shouldSetImageWithFadeAnimation {
                                if !base.isHighlighted { base.layer.removeAnimation(forKey: "_KFadeAnimationKey") }
                                let transition = CATransition()
                                transition.duration = 0.2
                                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                                transition.type = .fade
                                base.layer.add(transition, forKey: "_KFadeAnimationKey")
                            }
                            base.image = image
                        } else {
                            base.image = placeholder
                        }
        })
    }
}
