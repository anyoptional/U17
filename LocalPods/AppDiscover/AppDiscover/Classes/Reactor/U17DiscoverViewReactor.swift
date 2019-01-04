//
//  U17DiscoverViewReactorswift
//  AppDiscover
//
//  Created by Archer on 2018/11/20.
//

import Fate
import RxMoya
import RxSwift
import RxOptional
import ReactorKit

final class U17DiscoverViewReactor: Reactor {
    
    enum Action {
        // 获取默认详情
        case getStaticDetail(String)
        // 获取实时详情
        case getRealtimeDetail(String)
        // 获取猜你喜欢
        case getGuessLikeList(String)
    }
    
    enum Mutation {
        case setError(APIError)
    }
    
    struct State {
        var error: APIError?
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
        }
        
        return state
    }
}

extension U17DiscoverViewReactor {
    private func getStaticDetail(_ comicId: String) -> Observable<Mutation> {
        return .empty()
    }
    
    private func getRealtimeDetail(_ comicId: String) -> Observable<Mutation> {
        return .empty()
    }
    
    private func getGuessLikeList(_ comicId: String) -> Observable<Mutation> {
        return .empty()
    }
}
