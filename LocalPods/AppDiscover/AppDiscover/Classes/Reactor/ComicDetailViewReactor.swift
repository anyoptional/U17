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
    
    typealias Section = ComicDetailSection
    typealias StaticObject = ComicStaticDetailResp
    typealias StaticResponse = ComicStaticDetailResp.DataBean.ReturnDataBean
    typealias GuessLikeObject = ComicGuessLikeResp
    typealias GuessLikeResponse = ComicGuessLikeResp.DataBean.ReturnDataBean
    
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
        case setGuessLikeResponse(GuessLikeResponse)
    }
    
    struct State {
        var error: APIError?
        var sections = [Section]()
        var staticResponse: StaticResponse?
        var guessLikeResponse: GuessLikeResponse?
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
            // 这个就不可能没有章节列表数据了
            // empty的状态不用管了
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
            // fake data
            state.sections.insert(.chapter(items: Array(repeating: ComicChapterCellDisplay(rawValue: "hello world"), count: 10).map { .chapter(item: $0) }), at: 0)
            
        case .setGuessLikeResponse(let response):
            // 记录response
            state.guessLikeResponse = response
            // 添加table view 的 section
            state.sections.append(.guessLike(items: [.guessLike(item: ComicGuessLikeCellDisplay(rawValue: response))]))
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
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
    
    private func getRealtimeDetail(_ comicId: String?) -> Observable<Mutation> {
        return .empty()
    }
    
    private func getGuessLikeList(_ comicId: String?) -> Observable<Mutation> {
        let req = GuessLikeReq()
        req.comic_id = comicId
        return APIProvider.rx.request(DiscoverAPI.getGuessLikeList(req))
            .mapObject(GuessLikeObject.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setGuessLikeResponse($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
}

