//
//  TodayReq.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import Foundation

@objcMembers
class TodayReq: NSObject {
    var day = "6"
    var android_id = "iphone"
    var time = Int32(Date().timeIntervalSince1970)
    var device_id = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var key = """
2158a2da6424d7274cd3937a1c4f520721c6986830c2fdbbcf59e5e480ca5e9ce83ab3dd1ff92f0df537be9394acecb7f4974bd87c36990760fbb26cd5951826ee10af5100ac4321a6ea5e4712b9164284ef793fb73d5586:::u17
"""
    var model = "iPhone 6s"
    var target = "U17_3.0"
    var version = "4.3.12"
    var systemVersion = UIDevice.current.systemVersion
}

@objcMembers
class TodayRecommandListReq: TodayReq {}

