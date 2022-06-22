//
//  WishlistViewModel.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/22.
//

import RxCocoa
import RxSwift


class WishlistViewModel {
    
    enum Action {
        case fetchWishlist
    }
    
    enum Mutation {
        case setWishlist([Goods])
    }
    
    struct Store {
        var wishlist: [Goods] = []
    }
    
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    private(set) var store: Store
    
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    let service: WishlistServiceProtocol
    
    
    // MARK: Initializing
    
    init(service: WishlistServiceProtocol = WishlistService()) {
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
        case .fetchWishlist:
            return service.fetchWishlist()
                .asObservable()
                .map { .setWishlist($0) }
            
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setWishlist(let list):
            store.wishlist = list
            
        }
        
        return .just(store)
    }
    
}
