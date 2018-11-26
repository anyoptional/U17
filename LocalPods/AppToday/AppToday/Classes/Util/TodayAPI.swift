//
//  TodayAPI.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import RxMoya

enum TodayAPI {
    case getRecommandList(JSONParamConvertible)
}

extension TodayAPI: APITargetType {
    var host: APIHost {
        switch self {
        case .getRecommandList: return "http://app.u17.com/v3/appV3_3/ios/phone"
        }
    }
    
    var path: APIPath {
        switch self {
        case .getRecommandList: return "list/todayRecommendList"
        }
    }
    
    var method: APIMethod {
        switch self {
        case .getRecommandList:
            return .get
        }
    }
    
    var parameters: APIParameters {
        switch self {
        case let .getRecommandList(req):
            return req.asParameters()
        }
    }
}
