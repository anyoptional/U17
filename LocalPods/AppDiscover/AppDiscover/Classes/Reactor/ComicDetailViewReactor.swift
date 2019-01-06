//
//  ComicDetailViewReactor.swift
//  AppDiscover
//
//  Created by Archer on 2018/12/28.
//

import Fate
import RxMoya
import RxSwift
import RxOptional
import ReactorKit

final class ComicDetailViewReactor: Reactor {
    
    typealias StaticObject = ComicStaticDetailResp
    typealias StaticResponse = ComicStaticDetailResp.DataBean.ReturnDataBean
    
    enum Action {
        // 获取默认详情
        case getStaticDetail(String?)
        // 获取实时详情
        case getRealtimeDetail(String?)
        // 获取猜你喜欢
        case getGuessLikeList(String?)
    }
    
    enum Mutation {
        case setError(APIError)
        case setStaticResponse(StaticResponse)
    }
    
    struct State {
        var error: APIError?
        var staticResponse: StaticResponse?
        var imageViewDisplay: ComicImageViewDisplay?
        var previewViewDisplay: ComicPreviewViewDisplay?
        var placeholderState = U17PlaceholderView.State.loading
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getStaticDetail(let comicId):
            return getStaticDetail(comicId)
            
        case .getRealtimeDetail(let comicId):
            return getRealtimeDetail(comicId)
            
        case .getGuessLikeList(let comicId):
            return getGuessLikeList(comicId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        switch mutation {
        case .setError(let error):
            state.error = error
            // 没网显示占位图
            if APIError.networkRelated.contains(error)  {
                state.placeholderState = .failed
            } else {
                state.placeholderState = .completed
            }
            
        case .setStaticResponse(let response):
            // 记录response
            state.staticResponse = response
            // 背景图数据
            state.imageViewDisplay = ComicImageViewDisplay(rawValue: response)
            // 预览层数据
            state.previewViewDisplay = ComicPreviewViewDisplay(rawValue: response)
        }
        
        return state
    }
}

extension ComicDetailViewReactor {
    private func getStaticDetail(_ comicId: String?) -> Observable<Mutation> {
        let req = StaticDetailReq()
        req.comicid = comicId
        return APIProvider.rx.request(DiscoverAPI.getStaticDetail(req))
            .mapObject(StaticObject.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setStaticResponse($0) }
    }
    
    private func getRealtimeDetail(_ comicId: String?) -> Observable<Mutation> {
        return .empty()
    }
    
    private func getGuessLikeList(_ comicId: String?) -> Observable<Mutation> {
        return .empty()
    }
}

