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
    
    static func setObject(_ json: JSONObject, forTarget target: APITargetType, ignoredKeys: [String] = []) {
        let cacheKey = cacheKeyWithTarget(target, ignoredKeys: ignoredKeys)
        _cache?.setObject(json as NSString, forKey: cacheKey, with: nil)
    }
    
    static func objectForTarget(_ target: APITargetType, ignoredKeys: [String] = []) -> JSONObject? {
        let cacheKey = cacheKeyWithTarget(target, ignoredKeys: ignoredKeys)
        return _cache?.object(forKey: cacheKey) as? JSONObject
    }
    
    private static func cacheKeyWithTarget(_ target: APITargetType, ignoredKeys: [String] = []) -> String {
        if target.parameters.isEmpty { return target.baseURL.absoluteString + target.path }
        var parameters = target.parameters
        ignoredKeys.forEach { parameters.removeValue(forKey: $0) }
        let sortedParameters = parameters.sorted(by: { $0.key > $1.key })
        var paramString = "?"
        for index in sortedParameters.indices {
            paramString.append("\(sortedParameters[index].key)=\(sortedParameters[index].value)")
            if index != sortedParameters.count - 1 { paramString.append("&") }
        }
        return target.baseURL.absoluteString + target.path + "\(paramString)"
    }
}

#if false
extension String {
    func urlEncode() -> String {
        // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
    }
}
#endif
