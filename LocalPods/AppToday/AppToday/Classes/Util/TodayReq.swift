//
//  TodayReq.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import Foundation

@objcMembers
class TodayReq: NSObject {
    var time = Int32(Date().timeIntervalSince1970)
    var device_id = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var key = """
fabe6953ce6a1b8738bd2cabebf893a472d2b6274ef7ef6f6a5dc7171e5cafb14933ae65c70bceb97e0e9d47af6324d50394ba70c1bb462e0ed18b88b26095a82be87bc9eddf8e548a2a3859274b25bd0ecfce13e81f8317cfafa822d8ee486fe2c43e7acd93e9f19fdae5c628266dc4762060f6026c5ca83e865844fc6beea59822ed4a70f5288c25edb1367700ebf5c78a27f5cce53036f1dac4a776588cd890cd54f9e5a7adcaeec340c7a69cd986:::open
"""
    var model = "none"
    var target = "U17_3.0"
    var version = "3.0.0"
}

@objcMembers
class TodayRecommandListReq: TodayReq {}

