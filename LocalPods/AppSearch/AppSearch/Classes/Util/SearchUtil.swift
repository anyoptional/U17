//
//  SearchUtil.swift
//  AppSearch
//
//  Created by Archer on 2018/12/4.
//

import Fate

class AppSearchBundleLoader: NSObject {}

extension Bundle {
    static let resourcesBundle: Bundle? = {
        var path = Bundle(for: AppSearchBundleLoader.self).resourcePath ?? ""
        path.append("/AppSearch.bundle")
        return Bundle(path: path)
    }()
}

extension UIImage {
    convenience init?(nameInBundle name: String) {
        self.init(named: name, in: .resourcesBundle, compatibleWith: nil)
    }
}

/// 简易的关键词存储
struct U17KeywordsCache {
    
    static func store(_ keyword: String?) {
        guard let keyword = keyword else { return }
        if cache == nil {
            cache = getCachedKeywords()
        }
        // 效率稍微好点(相比先remove再insert)
        if let i = cache!.firstIndex(of: keyword) {
            let e = cache![i]
            for j in (0..<i).reversed() {
                cache![j + 1] = cache![j]
            }
            cache![0] = e
        } else {
            cache!.insert(keyword, at: 0)
        }
    }
    
    static func restore() -> [String] {
        if cache == nil {
            cache = getCachedKeywords()
        }
        return cache!
    }
    
    static func removeAll() {
        cache?.removeAll()
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "_kU17KeywordsCacheKey")
    }
    
    static func synchronize() {
        // 当前runloop空闲时再写
        // 这个缓存属于一个优先级比较低的操作
        // 即使慢一点写进去也没什么关系
        FDTransaction.default.commit {
            let cacheDump = cache
            cache = nil
            let defaults = UserDefaults.standard
            defaults.set(cacheDump, forKey: "_kU17KeywordsCacheKey")
            defaults.synchronize()
        }
    }
    
    // 这样写主要是为了能释放缓存
    private static var cache: [String]? = nil
    private static func getCachedKeywords() -> [String] {
        let defaults = UserDefaults.standard
        let object = defaults.object(forKey: "_kU17KeywordsCacheKey")
        return (object as? [String]) ?? []
    }
}
