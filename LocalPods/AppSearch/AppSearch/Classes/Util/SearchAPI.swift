//
//  SearchAPI.swift
//  AppSearch
//
//  Created by Archer on 2018/12/5.
//

import RxMoya

enum SearchAPI {
    case getHotKeywords(JSONParamConvertible)
}

extension SearchAPI: APITargetType {
    var host: APIHost {
        switch self {
        case .getHotKeywords: return "http://app.u17.com/v3/appV3_3/ios/phone"
        }
    }
    
    var path: APIPath {
        switch self {
        case .getHotKeywords: return "search/hotkeywordsnew"
        }
    }
    
    var method: APIMethod {
        switch self {
        case .getHotKeywords:
            return .get
        }
    }
    
    var parameters: APIParameters {
        switch self {
        case let .getHotKeywords(req):
            return req.asParameters()
        }
    }
}
