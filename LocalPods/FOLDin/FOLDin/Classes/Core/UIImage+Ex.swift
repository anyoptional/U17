//
//  UIImage+Ex.swift
//  FOLDin
//
//  Created by Archer on 2018/12/12.
//  Copyright © 2018年 Archer. All rights reserved.
//

import UIKit

extension UIImage {
    static func create(_ color: UIColor, _ size: CGSize = CGSize(width: 1, height: 0.5)) -> UIImage? {
        if size.width <= 0 || size.height <= 0 { return nil }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
