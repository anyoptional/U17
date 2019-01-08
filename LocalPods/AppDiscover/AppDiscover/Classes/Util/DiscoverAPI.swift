//
//  DiscoverAPI.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/4.
//

import RxMoya

enum DiscoverAPI {
    case getStaticDetail(JSONParamConvertible)
    case getRealtimeDetail(JSONParamConvertible)
    case getGuessLikeList(JSONParamConvertible)
}

extension DiscoverAPI: APITargetType {
    var host: APIHost {
        return "http://app.u17.com/v3/appV3_3/ios/phone"
    }
    
    var path: APIPath {
        switch self {
        case .getStaticDetail: return "comic/detail_static_new"
            
        case .getGuessLikeList: return "comic/guessLike"
            
        case .getRealtimeDetail: return "comic/detail_realtime"
        }
    }
    
    var method: APIMethod {
        return .get
    }
    
    var parameters: APIParameters {
        switch self {
        case let .getStaticDetail(req):
            return req.asParameters()
            
        case let .getRealtimeDetail(req):
            return req.asParameters()
            
        case let .getGuessLikeList(req):
            return req.asParameters()
        }
    }
}

