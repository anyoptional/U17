//
//  TodayViewReactor.swift
//  AppToday
//
//  Created by Archer on 2018/11/20.
//

import Fate
import RxMoya
import RxSwift
import ReactorKit

final class TodayViewReactor: Reactor {
    
    typealias Section = TodayRecommendSection
    typealias SectionItem = Section.Item
    typealias ObjectType = TodayRecommendResp
    typealias ResponseType = TodayRecommendResp.DataBean.ReturnDataBean
    
    enum Action {
        case getRecommendList
    }
    
    enum Mutation {
        case setError(APIError)
        case setRecommendResp(ResponseType)
    }
    
    struct State {
        var error: APIError?
        var sections = [Section]()
        var refreshState = U17RefreshState()
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getRecommendList:
            return getRecommendList()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        switch mutation {
        case .setError(let error):
            state.error = error
            
        case .setRecommendResp(let resp):
            state.refreshState.downState = .idle
            state.refreshState.upState = resp.hasMore ? .idle : .noMoreData
            state.sections = [Section(items: (resp.comics?.map { SectionItem(rawValue: $0) }).filterNil([]))]
        }
        return state
    }
}

extension TodayViewReactor {
    private func getRecommendList() -> Observable<Mutation> {
        let recommendListReq = TodayRecommendListReq()
        recommendListReq.day = "4"
        return APIProvider.rx.request(TodayAPI.getRecommendList(recommendListReq),
                                      allowsURLCache: true, ignoredKeys: ["time"])
            .mapObject(ObjectType.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setRecommendResp($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
}
