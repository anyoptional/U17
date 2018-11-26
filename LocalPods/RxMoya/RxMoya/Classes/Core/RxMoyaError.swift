//
//  RxMoyaError.swift
//  RxMoya
//
//  Created by Archer on 2018/11/19.
//

import Foundation

/// HTTP请求错误汇总
public enum APIError: Error {
    /// 未知错误
    case unknown
    /// 请求超时
    case timedOut
    /// 找不到服务器
    case cannotFindHost
    /// 无法连接服务器
    case cannotConnectToHost
    /// 没有连接互联网
    case notConnectedToInternet
    /// 后台返回转json字符串出错
    case stringMapping
    /// 非HTTP成功状态码
    case statusCode(Int)
    /// 其他奇奇怪怪的错误
    case underlying(Error)
}

/// Swift Error转APIError
/// 用于网络请求时的catch操作
public extension Error {
    public var apiError: APIError {
        return (self as? APIError) ?? .unknown
    }
}
