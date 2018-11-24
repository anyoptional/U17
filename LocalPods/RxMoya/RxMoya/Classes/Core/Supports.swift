//
//  Supports.swift
//  RxMoya
//
//  Created by Archer on 2018/11/19.
//

import Moya
import YYKit
import Alamofire

/// Some typealiases for increase readability
public typealias JSONObject = String
public typealias APIHost = String
public typealias APIPath = String
public typealias APITask = Moya.Task
public typealias APIMethod = Moya.Method
public typealias APIParameters = Alamofire.Parameters

/// Converts json object to intent object type
public protocol JSONObjectConvertible: class {
    static func object(withJSON json: JSONObject) -> Self?
}

extension NSObject : JSONObjectConvertible {
    public static func object(withJSON json: JSONObject) -> Self? {
        return model(withJSON: json)
    }
}

/// Encode object to json param, possibly key-value pairs
public protocol JSONParamConvertible: class {
    func asParameters() -> APIParameters
}

extension NSObject: JSONParamConvertible {
    public func asParameters() -> APIParameters {
        let validJSON = modelToJSONObject()
        return (validJSON as? APIParameters) ?? [:]
    }
}

/// Global provider instance
public let APIProvider: Moya.MoyaProvider<Moya.MultiTarget> = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 30
    let manager = Manager(configuration: configuration)
    manager.startRequestsImmediately = false
    return Moya.MoyaProvider<Moya.MultiTarget>(manager: manager)
}()

/// Represent a request
public protocol APITargetType: Moya.TargetType {
    var host: APIHost { get }
    var parameters: APIParameters { get }
}
/// Provide app-based default value for TargetType
public extension APITargetType {
    /// target based URL
    public var baseURL: URL { return URL(string: host)! }
    /// we don't need provide test data, so ignore it
    public var sampleData: Data { return Data() }
    /// by default, no parameters provided
    public var parameters: APIParameters { return [:] }
    /// app-based task
    public var task: APITask {
        switch method {
        case .get:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .post:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    /// we use application/json as our default Content-type
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

