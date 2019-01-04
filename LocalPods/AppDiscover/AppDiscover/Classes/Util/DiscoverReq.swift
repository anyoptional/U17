//
//  DiscoverReq.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/4.
//

import Foundation

@objcMembers
class DiscoverReq: NSObject {
    var time = Int32(Date().timeIntervalSince1970)
    var device_id = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var model = "iPhone 6s"
    var target = "U17_3.0"
    var version = "4.3.12"
    var systemVersion = UIDevice.current.systemVersion
}

@objcMembers
class GuessLikeReq: DiscoverReq {
    var comic_id: String?
}

@objcMembers
class StaticDetailReq: DiscoverReq {
    var v = "3320110" // wtf?!
    var comicid: String?
}

typealias RealtimeDetailReq = StaticDetailReq
