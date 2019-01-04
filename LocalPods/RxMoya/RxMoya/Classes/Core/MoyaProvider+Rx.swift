//
//  MoyaProvider+Rx.swift
//  RxMoya
//
//  Created by Archer on 2018/11/19.
//

import Moya
import RxSwift

/// Extends reactive proxy
extension MoyaProvider: ReactiveCompatible {}

/// Reactive extension for MoyaProvider
public extension Reactive where Base: Moya.MoyaProvider<Moya.MultiTarget> {
    /// Sends a HTTP request.
    ///
    /// - Parameters:
    ///   - token: The token for request.
    ///   - allowsURLCache: Allows cache respose or not.
    ///   - ignoredKeys: The ignorable keys in parameters.
    /// - Returns: Observable sequence that contains response json
    public func request(_ token: APITargetType, allowsURLCache: Bool = false, ignoredKeys: [String] = []) -> Observable<JSONObject> {
        return Observable.create { [weak base = base] observer in
            /// load cache first
            if allowsURLCache {
                if let jsonObject = Cache.objectForTarget(token, ignoredKeys: ignoredKeys) {
                    observer.onNext(jsonObject)
                }
            }
            /// send request
            let cancellableToken = base?.request(Base.Target(token), callbackQueue: nil, progress: nil) { result in
                result.analysis(ifSuccess: { (response) in
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        let jsonObject = try response.mapString()
                        /// store in cache
                        if allowsURLCache { Cache.setObject(jsonObject, forTarget: token, ignoredKeys: ignoredKeys) }
                        /// emit element
                        observer.onNext(jsonObject)
                        /// unsubscribe
                        observer.onCompleted()
                    } catch MoyaError.statusCode(let response) {
                        observer.onError(APIError.statusCode(response.statusCode))
                    } catch MoyaError.stringMapping {
                        observer.onError(APIError.stringMapping)
                    } catch {
                        /// possibly unreachable, all error has catached above
                        debugPrint("UnknownError = ", error)
                        observer.onError(APIError.unknown)
                    }
                }, ifFailure: { (error) in
                    if case let .underlying(error, _) = error,
                        let urlError = error as? URLError {
                        if urlError.code == URLError.timedOut {
                            observer.onError(APIError.timedOut)
                        } else if urlError.code == URLError.cannotFindHost {
                            observer.onError(APIError.cannotFindHost)
                        } else if urlError.code == URLError.cannotConnectToHost {
                            observer.onError(APIError.cannotConnectToHost)
                        } else if urlError.code == URLError.notConnectedToInternet {
                            observer.onError(APIError.notConnectedToInternet)
                        } else {
                            observer.onError(APIError.underlying(urlError))
                        }
                    } else {
                        debugPrint("MoyaError = ", error)
                        observer.onError(APIError.underlying(error))
                    }
                })
            }
            return Disposables.create { cancellableToken?.cancel() }
        }.observeOn(MainScheduler.instance)
        /// ignore when cache is same as network response
        .distinctUntilChanged()
        /// retry when failed and shares resources
        .retry(3).share(replay: 1, scope: .forever)
    }
}
