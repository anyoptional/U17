//
//  Cache.swift
//  RxMoya
//
//  Created by Archer on 2018/11/19.
//

import YYKit

/// Simple cache based on YYCache
struct Cache {
    // the underlying cache instance
    private static let _cache = YYCache(name: "com.rx-moya.cache")
    
    static func setObject(_ json: JSONObject, forTarget target: APITargetType) {
        let cacheKey = cacheKeyWithTarget(target)
        _cache?.setObject(json as NSString, forKey: cacheKey, with: nil)
    }
    
    static func objectForTarget(_ target: APITargetType) -> JSONObject? {
        let cacheKey = cacheKeyWithTarget(target)
        return _cache?.object(forKey: cacheKey) as? JSONObject
    }
    
    private static func cacheKeyWithTarget(_ target: APITargetType) -> String {
        if target.parameters.isEmpty { return target.baseURL.absoluteString + target.path }
        do {
            let paramData = try JSONSerialization.data(withJSONObject: target.parameters, options: [])
            if let paramString = String(data: paramData, encoding: .utf8) {
                return target.baseURL.absoluteString + target.path + "\(paramString)"
            }
        } catch {
            fatalError("could not serialize patameters")
        }
        
        return target.baseURL.absoluteString + target.path
    }
}
