//
//  ExNumberType.swift
//  Fate
//
//  Created by Archer on 2018/11/23.
//

import Foundation

public extension Bool {
    public func toInt() -> Int {
        return (self == true) ? 1 : 0
    }
    
    public func toCGFloat() -> CGFloat {
        return toInt().toCGFloat()
    }
    
    public func toDouble() -> Double {
        return toInt().toDouble()
    }
    
    public func toString() -> String {
        return (self == true) ? "true" : "false"
    }
}

public extension Int {
    public func toBool() -> Bool {
        return self != 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    public func toDouble() -> Double {
        return Double(self)
    }
    
    public func toString() -> String {
        return String(self)
    }
}

public extension CGFloat {
    public func toBool() -> Bool {
        return self != 0
    }
    
    public func toInt() -> Int {
        return Int(self)
    }
    
    public func toDouble() -> Double {
        return Double(self)
    }
    
    public func toString() -> String {
        return String(self.toDouble())
    }
}

public extension Double {
    public func toBool() -> Bool {
        return self != 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    public func toInt() -> Int {
        return Int(self)
    }
    
    public func toString() -> String {
        return String(self)
    }
}

public extension String {
    public func toBool() -> Bool {
        return toDouble().toBool()
    }
    
    public func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    public func toDouble() -> Double {
        return Double(self) ?? 0
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self.toDouble())
    }
}
