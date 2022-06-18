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
        case fetchGoods(lastId: Int)
    }
    
    enum Mutation {
        case setHomeData(HomeData?)
        case setGoods([Goods])
    }
    
    struct Store {
        var homeData: HomeData?
        var goods: [Goods] = []
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
                .map { .setHomeData($0) }
            
        case .fetchGoods(let id):
            return service
                .fetchGoods(with: id)
                .asObservable()
                .map { .setGoods($0) }
            
            
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setHomeData(let data):
            store.homeData = data
            
        case .setGoods(let goods):
            store.goods = goods
        }
        
        return .just(store)
    }
    
}
