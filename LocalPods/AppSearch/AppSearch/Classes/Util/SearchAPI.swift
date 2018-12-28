//
//  SearchAPI.swift
//  AppSearch
//
//  Created by Archer on 2018/12/5.
//

import RxMoya

enum SearchAPI {
    case getHotKeywords(JSONParamConvertible)
    case getSearchResult(JSONParamConvertible)
    case getKeywordRelative(JSONParamConvertible)
}

extension SearchAPI: APITargetType {
    var host: APIHost {
        return "http://app.u17.com/v3/appV3_3/ios/phone"
    }
    
    var path: APIPath {
        switch self {
        case .getHotKeywords: return "search/hotkeywordsnew"
        case .getKeywordRelative: return "search/relative"
        case .getSearchResult: return "search/searchResult"
        }
    }
    
    var method: APIMethod {
        return .get
    }
    
    var parameters: APIParameters {
        switch self {
        case let .getHotKeywords(req):
            return req.asParameters()
            
        case let .getKeywordRelative(req):
            return req.asParameters()
            
        case let .getSearchResult(req):
            return req.asParameters()
        }
    }
}
