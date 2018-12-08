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
    
    public var message: String {
        switch self {
        case .unknown:
            return "未知错误"
        case .timedOut:
            return "请求超时"
        case .cannotFindHost:
            return "找不到服务器"
        case .cannotConnectToHost:
            return "无法连接服务器"
        case .notConnectedToInternet:
            return "网络未连接"
        case .stringMapping:
            return "JSON解析错误"
        case .statusCode(let code):
            return "请求失败, code = \(code)"
        case .underlying(let error):
            return "请求失败, error = \(error)"
        }
    }
}

extension APIError {
    /// 网络相关的错误
    public static var networkRelated: [APIError] {
        return [.timedOut,
                .cannotFindHost,
                .cannotConnectToHost,
                .notConnectedToInternet]
    }
}

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        // only compare network related errors
        case (.timedOut, .timedOut): return true
        case (.cannotFindHost, .cannotFindHost): return true
        case (.cannotConnectToHost, .cannotConnectToHost): return true
        case (.notConnectedToInternet, .notConnectedToInternet): return true
        // ignore other errors
        case _: return false
        }
    }
}

/// Swift Error转APIError
/// 用于网络请求时的catch操作
public extension Error {
    public var apiError: APIError {
        return (self as? APIError) ?? .unknown
    }
}
