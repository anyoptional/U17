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
        case setRecommandResp([ObjCType.DataBean.ReturnDataBean.DayDataListBean])
    }
    
    struct State {
        var error: APIError?
        var sections = [Section]()
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
            state.sections.removeAll(keepingCapacity: true)
            state.sections += resp.map { Section.dayItemDataList(items: ($0.dayItemDataList?.map { SectionItem.dayItemData(item: TodayRecommandCellDisplay(rawValue: $0)) }).filterNil([]) ) }
        }
        return state
    }
}

extension TodayViewReactor {
    private func getRecommandList() -> Observable<Mutation> {
        let recommandListReq = TodayRecommandListReq()
        return APIProvider.rx.request(TodayAPI.getRecommandList(recommandListReq), cacheable: true)
            .mapObject(ObjCType.self)
            .map { $0.data?.returnData?.dayDataList }
            .filterNil()
            .map { Mutation.setRecommandResp($0) }
            .catchError({ (error) -> Observable<Mutation> in
                if let error = error as? APIError {
                    return Observable.just(Mutation.setError(error))
                } else {
                    return Observable.just(Mutation.setError(APIError.unknown))
                }
            })
    }
}
