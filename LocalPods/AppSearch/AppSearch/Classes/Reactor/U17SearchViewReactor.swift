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
    
    typealias Section = U17SearchSection
    typealias HotObject = HotKeywordsResp
    typealias HotResponse = HotKeywordsResp.DataBean.ReturnDataBean
    typealias RelativeObject = KeywordRelativeResp
    typealias RelativeResponse = KeywordRelativeResp.DataBean.ReturnDataBean
    typealias SearchResultObject = SearchResultResp
    typealias SearchResultResponse = SearchResultResp.DataBean.ReturnDataBean
    
    enum Action {
        // 获取关键词 热门和历史
        case getKeywords
        // 刷新热门词
        case refreshHotKeywords
        // 清空历史记录
        case removeHistoryKeywords
        // 关键词搜索
        case getKeywordRelative(String)
        // 点击历史记录
        case getSearchResult(String)
    }
    
    enum Mutation {
        case setError(APIError)
        case addHistoryKeywords([String])
        case removeHistoryKeywords
        case addHotKeywords(HotResponse)
        case refreshHotKeywords(HotResponse)
        case addKeywordRelative([RelativeResponse])
        case addSearchResult(SearchResultResponse)
        
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
        case .getKeywords:
            return getKeywords()
            
        case .refreshHotKeywords:
            return refreshHotKeywords()
            
        case .removeHistoryKeywords:
            return removeHistoryKeywords()
            
        case .getKeywordRelative(let keyword):
            return getKeywordRelative(keyword)
            
        case .getSearchResult(let keyword):
            return getSearchResult(keyword)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        switch mutation {
        case .setError(let error):
            state.error = error
            // 没数据且没网才显示
            if state.sections.isEmpty &&
                APIError.networkRelated.contains(error)  {
                state.placeholderState = .failed
            } else {
                state.placeholderState = .completed
            }
            
        case .addHistoryKeywords(let keywords):
            // 先清空所有数据 避免和relative数据混在一起
            state.sections.removeAll(keepingCapacity: true)
            if keywords.isEmpty { break }
            state.placeholderState = .completed
            state.sections += [.history(items: keywords.map({ (rawValue) in
                .history(item: U17HistorySearchCellDisplay(rawValue: rawValue))
            }))]
            
        case .addHotKeywords(let resp):
            // 讲道理 历史搜索可能没有
            // 热门总不能没有吧 所以这里就不做判空了
            state.placeholderState = .completed
            state.placeholderText = resp.defaultSearch
            let hot: Section = .hot(items: [.hot(item: U17HotSearchCellDisplay(rawValue: resp))])
            // 暂无section 那么就做第一段处理
            if state.sections.isEmpty {
                state.sections = [hot]
            } else {
                // 有历史记录的话就插入到第一个
                state.sections.insert(hot, at: 0)
            }
            
        case .addKeywordRelative(let resps):
            if resps.isEmpty {
                state.placeholderState = .empty
            } else {
                state.placeholderState = .completed
            }
            state.sections = [.relative(items: resps.map({ (rawValue) in
                .relative(item: U17KeywordRelativeCellDisplay(rawValue: rawValue))
            }))]
            
        case .refreshHotKeywords(let resp):
            // 能点击刷新说明一定有热门词
            // 这里直接操作下标0没有问题
            let hotItems: [Section.Item] =  [.hot(item: U17HotSearchCellDisplay(rawValue: resp))]
            state.sections.replace(section: 0, items: hotItems)
            
        case .removeHistoryKeywords:
            // 避免连续点击越界
            if state.sections.isNotEmpty {
                state.sections.removeLast()
            }
            // 可能是最后一段(网络差未请求到热门词时)
            // 这里也追加一下判空操作
            if state.sections.isEmpty {
                state.placeholderState = .empty
            } else {
                state.placeholderState = .completed
            }
            
        case .addSearchResult(let resp):
            let comics = resp.comics.filterNil([])
            // 设置占位图的状态
            if comics.isEmpty {
                state.placeholderState = .empty
            } else {
                state.placeholderState = .completed
            }
            // 设置section
            state.sections = [.searchResult(items: comics.map({ (rawValue) in
                .searchResult(item: U17SearchResultCellDisplay(rawValue: rawValue))
            }))]
        }
        return state
    }
}

extension U17SearchViewReactor {
    private func getKeywords() -> Observable<Mutation> {
        // 先读缓存 再请求后台
        return Observable.concat([getHistoryKeywords(),
                                  getHotKeywords()])
    }
    
    private func getHotKeywords() -> Observable<Mutation> {
        return requestHotKeywords(isRefresh: false)
    }
    
    private func refreshHotKeywords() -> Observable<Mutation> {
        return requestHotKeywords(isRefresh: true)
    }
    
    private func requestHotKeywords(isRefresh: Bool) -> Observable<Mutation> {
        let req = HotKeywordsReq()
        return APIProvider.rx.request(SearchAPI.getHotKeywords(req))
            .mapObject(HotObject.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { (keywords) in
                if isRefresh {
                    return Mutation.refreshHotKeywords(keywords)
                }
                return Mutation.addHotKeywords(keywords)
            }.catchError { .just(Mutation.setError($0.apiError)) }
    }
    
    private func getHistoryKeywords() -> Observable<Mutation> {
        return .just(Mutation.addHistoryKeywords(U17KeywordsCache.restore()))
    }
    
    private func removeHistoryKeywords() -> Observable<Mutation> {
        U17KeywordsCache.removeAll()
        return .just(Mutation.removeHistoryKeywords)
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
            }).map { Mutation.addKeywordRelative($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
    
    /// 这种搜索基本上不会搜出很多
    /// 简单点处理忽略上拉
    /// update 12.29: 我发现啊搜索`命运`出来了40个结果
    /// 然后呢这40个并没有分页，所以说啊，U17本身肯定也是
    /// 跟我一样的做法，所谓的`已经全部加载完毕`并不是refreshFooter啊~~
    private func getSearchResult(_ keyword: String) -> Observable<Mutation> {
        let searchResultReq = SearchResultReq()
        searchResultReq.page = 1
        searchResultReq.q = keyword
        return APIProvider.rx.request(SearchAPI.getSearchResult(searchResultReq))
            .mapObject(SearchResultObject.self)
            .map { $0.data?.returnData }
            .filterNil()
            .map { Mutation.addSearchResult($0) }
            .catchError { .just(Mutation.setError($0.apiError)) }
    }
}
