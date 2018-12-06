//
//  UILayoutAdaptor.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import YYKit

public let kScreenSize = YYScreenSize()
public let kScreenWidth = YYScreenSize().width
public let kScreenHeight = YYScreenSize().height

public enum iPhoneType {
    case iPhone5
    case iPhone6
    case iPhone6P
    case iPhoneX
    case iPhoneXR
}

public extension UIDevice {
    public static var isX: Bool {
        return UIDevice.type == .iPhoneX ||
            UIDevice.type == .iPhoneXR
    }
    
    public static var type: iPhoneType {
        let size = kScreenSize;
        if (size.width == 320.0 && size.height == 568.0) {
            return .iPhone5;
        } else if (size.width == 375.0 && size.height == 667.0) {
            return .iPhone6; // 6/7/8
        } else if(size.width == 414.0 && size.height == 736.0){
            return .iPhone6P; // 6p/7p/8p
        } else if(size.width == 375.0 && size.height == 812.0){
            return .iPhoneX; // X/Xs
        } else if(size.width == 414.0 && size.height == 896.0){
            return .iPhoneXR; // Xr/Xs Max
        } else {
            return .iPhone6;
        }
    }
}

/// Be careful, screen size may change unexpectly
public protocol UILayoutAdaptor {
    var scaledWidth: CGFloat { get }
    var scaledHeight: CGFloat { get }
    var cgFloatValue: CGFloat { get }
}

extension UILayoutAdaptor {
    public var scaledWidth: CGFloat {
        switch UIDevice.type {
        case .iPhone5, .iPhone6P, .iPhoneXR:
            return cgFloatValue * kScreenWidth / 375.0;
        case .iPhone6, .iPhoneX:
            return cgFloatValue
        }
    }
    public var scaledHeight: CGFloat {
        switch UIDevice.type {
        case .iPhone5, .iPhone6P, .iPhoneXR:
            return cgFloatValue * kScreenHeight / 667.0;
        case .iPhone6, .iPhoneX:
            return cgFloatValue
        }
    }
}

extension Int : UILayoutAdaptor {
    public var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
}
extension Double : UILayoutAdaptor {
    public var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
}
extension CGFloat : UILayoutAdaptor {
    public var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
}
public extension CGPoint {
    public var scaled: CGPoint {
        return CGPoint(x: x.scaledWidth, y: y.scaledHeight)
    }
}
public extension CGSize {
    public var scaled: CGSize {
        return CGSize(width: width.scaledWidth, height: height.scaledHeight);
    }
}
public extension CGRect {
    public var scaled: CGRect {
        return CGRect(origin: origin.scaled, size: size.scaled)
    }
}
