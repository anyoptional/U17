//
//  SwiftyCache.swift
//  Fate
//
//  Created by Archer on 2018/12/28.
//

import YYKit

/// 取代UserDefaults
public class SwiftyCache: YYCache {
    public static let shared = SwiftyCache(name: "com.archer.basic.cache")
}
