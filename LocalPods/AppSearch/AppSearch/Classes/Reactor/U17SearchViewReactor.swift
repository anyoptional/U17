//
//  U17SearchViewReactor.swift
//  AppSearch
//
//  Created by Archer on 2018/12/4.
//

import Fate
import RxMoya
import RxSwift
import RxOptional
import ReactorKit

final class U17SearchViewReactor: Reactor {
    
    typealias Section = SearchSection
    typealias ObjectType = HotKeywordsResp
    typealias ResponseType = HotKeywordsResp.DataBean.ReturnDataBean
    
    enum Action {
        case getHotKeywords
    }
    
    enum Mutation {
        case setError(APIError)
        case setHotKeywordsResp(ResponseType)
    }
    
    struct State {
        var error: APIError?
        var sections = [Section]()
        var placeholderText: String?
        var placeholderState = U17PlaceholderView.State.loading
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getHotKeywords:
            return getHotKeywords()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        switch mutation {
        case .setError(let error):
            state.error = error
            if APIError.networkRelated.contains(error)  {
                state.placeholderState = .failed
            } else {
                state.placeholderState = .completed
            }
            
        case .setHotKeywordsResp(let resp):
            state.placeholderState = .completed
            state.placeholderText = resp.defaultSearch
            state.sections = [.hot(section: 0, items: [.hot(row: 0, item: U17HotSearchCellDisplay(rawValue: resp))])]
        }
        return state
    }
}

extension U17SearchViewReactor {
    private func getHotKeywords() -> Observable<Mutation> {
        let req = HotKeywordsReq()
        return APIProvider.rx.request(SearchAPI.getHotKeywords(req))
            .mapObject(ObjectType.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setHotKeywordsResp($0) }
    }
}
