//
//  KeywordRelativeResp.swift
//
//  This file is auto generated by fit.
//  Github: https://github.com/AnyOptional/fit
//
//  Copyright © 2018-present Archer. All rights reserved.
//

import YYKit

@objcMembers
class KeywordRelativeResp: NSObject, YYModel {
    
    var data: DataBean?
    
    @objcMembers
    class DataBean: NSObject, YYModel {
        var stateCode: Int = 0
        var returnData: [ReturnDataBean]?
        
        @objcMembers
        class ReturnDataBean: NSObject, YYModel {
            var name: String?
            var comic_id: String?
            
            /// 用来做显示高亮
            var keyword: String?
        }
        
        var message: String?
        
        static func modelContainerPropertyGenericClass() -> [String : Any]? {
            return ["returnData" : ReturnDataBean.self]
        }
    }
    
    var code: Int = 0
}
