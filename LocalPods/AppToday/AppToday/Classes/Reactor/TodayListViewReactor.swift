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
    typealias Object = TodayRecommendResp
    typealias Response = TodayRecommendResp.DataBean.ReturnDataBean
    
    enum Action {
        case pullToRefresh(String?)
        case pullUpToRefresh(String?)
    }
    
    enum Mutation {
        case setError(APIError)
        case setSections(Response)
        case setSectionItems(Response)
    }
    
    struct State {
        var error: APIError?
        var sections = [Section]()
        var refreshState = U17RefreshState()
        var placeholderState = U17PlaceholderView.State.completed
    }
    
    var initialState = State()
    
    // 当前刷新的页数
    private var currentPage = 0

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pullToRefresh(let weekday):
            return pullToRefresh(weekday)
            
        case .pullUpToRefresh(let weekday):
            return pullUpToRefresh(weekday)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        switch mutation {
        case .setError(let error):
            state.error = error
            // 设置刷新控件的状态
            state.refreshState.upState = .idle
            state.refreshState.downState = .idle
            // 设置占位图的状态
            if state.sections.isEmpty &&
                APIError.networkRelated.contains(error) {
                state.placeholderState = .failed
            } else {
                state.placeholderState = .completed
            }
            
        case .setSections(let resp):
            // 判断刷新控件的状态
            state.refreshState.downState = .idle
            state.refreshState.upState = resp.hasMore ? .idle : .noMoreData
            // 设置section
            let sectionItems = (resp.comics?.map { Section.Item(rawValue: $0) }).filterNil([])
            state.sections = [Section(tag: "first blood", items: sectionItems)]
            // 设置占位图的状态
            if sectionItems.isEmpty {
                state.placeholderState = .empty
            } else {
                state.placeholderState = .completed
            }
            
        case .setSectionItems(let resp):
            // 判断刷新控件的状态
            state.refreshState.upState = resp.hasMore ? .idle : .noMoreData
            // 设置section
            let sectionItems = (resp.comics?.map { Section.Item(rawValue: $0) }).filterNil([])
            if state.sections.isEmpty {
                state.sections = [Section(tag: "first blood", items: sectionItems)]
            } else {
                // 当前cache体系下不好处理数据变动的问题
                // 所以上拉就不缓存了吧
                state.sections.insert(sectionItems, at: 0)
            }
            // 设置占位图的状态
            if state.sections[0].items.isEmpty {
                state.placeholderState = .empty
            } else {
                state.placeholderState = .completed
            }
        }
        return state
    }
}

extension TodayListViewReactor {
    // 下拉刷新
    private func pullToRefresh(_ weekday: String?) -> Observable<Mutation> {
        currentPage = 0
        let recommendListReq = TodayRecommendListReq()
        recommendListReq.day = weekday
        recommendListReq.page = currentPage
        return APIProvider.rx.request(TodayAPI.getRecommendList(recommendListReq),
                                      allowsURLCache: true, ignoredKeys: ["time"])
            .mapObject(Object.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setSections($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
    
    // 上拉加载
    private func pullUpToRefresh(_ weekday: String?) -> Observable<Mutation> {
        if currentPage == 0 {
            currentPage += 2 // wtf?!
        } else {
            currentPage += 1
        }
        let recommendListReq = TodayRecommendListReq()
        recommendListReq.day = weekday
        recommendListReq.page = currentPage
        return APIProvider.rx.request(TodayAPI.getRecommendList(recommendListReq))
            .mapObject(Object.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.setSectionItems($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
}

