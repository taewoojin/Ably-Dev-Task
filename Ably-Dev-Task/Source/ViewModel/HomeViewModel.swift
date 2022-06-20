//
//  HomeViewModel.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import RxCocoa
import RxSwift


class HomeViewModel {
    
    enum Action {
        case fetchHomeData
        case fetchGoods
        case refresh
    }
    
    enum Mutation {
        case setHomeData(HomeData?)
        case setGoods([Goods])
        case setIsRefresh(Bool)
    }
    
    struct Store {
        var homeData: HomeData?
        var goods: [Goods] = []
        var isRefresh: Bool = false
    }
    
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    private(set) var store: Store
    
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    let service: HomeServiceProtocol
    
    
    // MARK: Initializing
    
    init(service: HomeServiceProtocol = HomeService()) {
        self.service = service
        self.store = Store()
        
        action
            .flatMap(mutate)
            .flatMap(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }
    
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
            
        case .fetchHomeData:
            return service
                    .fetchHomeData()
                    .asObservable()
                    .flatMap { data -> Observable<Mutation> in
                        return Observable.merge([
                            .just(.setHomeData(data)),
                            .just(.setIsRefresh(false))
                        ])
                    }
            
        case .fetchGoods:
            guard let lastId = store.homeData?.goods.last?.id else {
                return .just(.setGoods([]))
            }
            
            return service
                .fetchGoods(with: lastId)
                .asObservable()
                .map { .setGoods($0) }
            
        case .refresh:
            return .just(.setIsRefresh(true))
            
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setHomeData(let data):
            store.homeData = data
            
        case .setGoods(let goods):
            store.homeData?.goods.append(contentsOf: goods)
            
        case .setIsRefresh(let isRefresh):
            store.isRefresh = isRefresh
            
        }
        
        return .just(store)
    }
    
}
