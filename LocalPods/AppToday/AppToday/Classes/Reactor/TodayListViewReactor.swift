//
//  TodayListViewReactor.swift
//  AppToday
//
//  Created by Archer on 2018/11/29.
//

import Fate
import RxMoya
import RxSwift
import ReactorKit

final class TodayListViewReactor: Reactor {
    
    typealias Section = TodayRecommendSection
    typealias ObjectType = TodayRecommendResp
    typealias ResponseType = TodayRecommendResp.DataBean.ReturnDataBean
    
    enum Action {
        case getRecommendList(String?)
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
        case .getRecommendList(let weekday):
            return getRecommendList(weekday)
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
            state.sections = [Section(items: (resp.comics?.map { Section.Item(rawValue: $0) }).filterNil([]))]
        }
        return state
    }
}

extension TodayListViewReactor {
    private func getRecommendList(_ weekday: String?) -> Observable<Mutation> {
        let recommendListReq = TodayRecommendListReq()
        recommendListReq.day = weekday
        return APIProvider.rx.request(TodayAPI.getRecommendList(recommendListReq),
                                      allowsURLCache: true, ignoredKeys: ["time"])
            .mapObject(ObjectType.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setRecommendResp($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
}

