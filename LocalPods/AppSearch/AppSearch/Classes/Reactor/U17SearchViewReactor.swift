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
    typealias HotObject = HotKeywordsResp
    typealias HotResponse = HotKeywordsResp.DataBean.ReturnDataBean
    typealias RelativeObject = KeywordRelativeResp
    typealias RelativeResponse = KeywordRelativeResp.DataBean.ReturnDataBean
    
    enum Action {
        case getHotKeywords
        case getKeywordRelative(String)
    }
    
    enum Mutation {
        case setError(APIError)
        case setHotKeywordsResp(HotResponse)
        case setKeywordRelativeResps([RelativeResponse])
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
            
        case .getKeywordRelative(let keyword):
            return getKeywordRelative(keyword)
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
            
        case .setKeywordRelativeResps(let resps):
            if resps.isEmpty {
                state.placeholderState = .empty
            } else {
                state.placeholderState = .completed
            }
            state.sections = [.relative(section: 0, items: resps.enumerated().map({ (row, rawValue) in
                .relative(row: row, item: U17KeywordRelativeCellDisplay(rawValue: rawValue))
            }))]
            break
        }
        return state
    }
}

extension U17SearchViewReactor {
    private func getHotKeywords() -> Observable<Mutation> {
        let req = HotKeywordsReq()
        return APIProvider.rx.request(SearchAPI.getHotKeywords(req))
            .mapObject(HotObject.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setHotKeywordsResp($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
    
    private func getKeywordRelative(_ keyword: String) -> Observable<Mutation> {
        let req = KeywordRelativeReq()
        req.inputText = keyword
        return APIProvider.rx.request(SearchAPI.getKeywordRelative(req))
            .mapObject(RelativeObject.self)
            .map { $0.data?.returnData }
            /// 如果没有数据就没有returnData
            /// 没有数据是使用data.stateCode的0/1来控制
            /// 这里提供一个默认值用来做占位图的.empty状态，效果一样
            .replaceNilWith([])
            .do(onNext: { (resps) in
                /// 将keyword添加进数据
                /// 便于接下来做高亮显示关键字
                resps.forEach { $0.keyword = keyword }
            }).map { Mutation.setKeywordRelativeResps($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
}
