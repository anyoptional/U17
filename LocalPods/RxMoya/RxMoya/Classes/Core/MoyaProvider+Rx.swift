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
    ///   - token: the token for request
    ///   - cacheable: cache respose or not
    /// - Returns: observable sequence that contains response json
    public func request(_ token: APITargetType, cacheable: Bool = false) -> Observable<JSONObject> {
        return Observable.create { [weak base = base] observer in
            /// load cache first
            if cacheable {
                if let jsonObject = Cache.objectForTarget(token) {
                    observer.onNext(jsonObject)
                }
            }
            /// send request
            let cancellableToken = base?.request(Base.Target(token), callbackQueue: nil, progress: nil) { result in
                result.analysis(ifSuccess: { (response) in
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        let jsonObject = try response.mapString()
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
        /// retry when failed and shares resources
        .retry(3).share(replay: 1, scope: .forever)
    }
}
