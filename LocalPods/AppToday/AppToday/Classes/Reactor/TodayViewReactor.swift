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
    
    typealias Section = TodayRecommandSection
    typealias SectionItem = Section.Item
    typealias ObjCType = TodayRecommandResp
    
    enum Action {
        case getRecommandList
    }
    
    enum Mutation {
        case setError(APIError)
        case setRecommandResp(ObjCType.DataBean.ReturnDataBean)
    }
    
    struct State {
        var error: APIError?
        var sections = [Section]()
        var refreshState = U17RefreshState()
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getRecommandList:
            return getRecommandList()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        switch mutation {
        case .setError(let error):
            state.error = error
            
        case .setRecommandResp(let resp):
            state.refreshState.downState = .idle
            state.refreshState.upState = resp.hasMore ? .idle : .noMoreData
            state.sections = [Section(items: (resp.comics?.map { SectionItem(rawValue: $0) }).filterNil([]))]
        }
        return state
    }
}

extension TodayViewReactor {
    private func getRecommandList() -> Observable<Mutation> {
        let recommandListReq = TodayRecommandListReq()
        return APIProvider.rx.request(TodayAPI.getRecommandList(recommandListReq),
                                      allowsURLCache: true, ignoredKeys: ["time"])
            .mapObject(ObjCType.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setRecommandResp($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
}
